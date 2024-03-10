extends Node2D

@onready var player = get_parent()

@export var coin_viewport: SubViewport
@export var ruby_viewport: SubViewport
@export var juice_viewport: SubViewport

# instantiated in game _ready
var item_spawner: Node

signal player_clicked(node)

var graph_node_scene = preload("res://scenes/graph/graph_node/graph_node.tscn")
var distance = 150;
var current_focus = null
var current_depth: int = 0
var current_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	current_focus = $RootNode.position
	
	expand($RootNode)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RootNode.position = $RootNode.position.lerp(current_focus, delta * 12)


func focus_on_depth(g_pos):
	current_focus = Vector2(g_pos.x * distance/2, -1 * g_pos.y * distance)


func bifurcate(node):
	
	var left_result = create_child_node(node, -1)
	var instance_left = left_result[0]
	if left_result[1]:
		instance_left.translate(Vector2(-distance/2, distance))
		node.add_child(instance_left)
	
	var right_result = create_child_node(node, +1)
	var instance_right = right_result[0]
	if right_result[1]:
		instance_right.translate(Vector2(distance/2, distance))
		node.add_child(instance_right)
		
		
	var line = Line2D.new()
	line.add_point(Vector2(-distance/2, distance))
	line.add_point(Vector2(0,0))
	line.add_point(Vector2(distance/2, distance))
	node.add_child(line)


# returns [node, <if node is newly created>]
func create_child_node(node, pos):
	var position = Vector2(node.graph_position.x - pos, node.graph_position.y + 1)
	var name = generate_name(position)

	for current_node in current_nodes:
		var existing_node = rec_graph_find_by_pos(current_node, position)
		if existing_node:
			if existing_node.parents.find(node) == -1:
				existing_node.parents.append(node)
			if node.children.find(existing_node) == -1:
				node.children.append(existing_node)
			return [existing_node, false]
		
	var instance = graph_node_scene.instantiate()
	instance.parents.append(node)
	node.children.append(instance)
	instance.graph_position = position
	instance.name = name
	instance.ruby_viewport = ruby_viewport
	instance.juice_viewport = juice_viewport
	instance.coin_viewport = coin_viewport
	instance.player = player
	
	instance.resource_type = random_resource_type()
	
	instance.clicked.connect(_on_node_clicked)
	return [instance, true]


func generate_name(g_pos):
	var x = 0
	var y = 0
	
	# this looks stupid but -0 is appearing in strings and messing up find_child()
	if abs(g_pos.x) == 0:
		x = 0
	else:
		x = g_pos.x
		
	if abs(g_pos.y) == 0:
		y = 0
	else:
		y = g_pos.y
		
	return "GraphNode(" + str(x) + ", " + str(y) + ")"


func expand(node):
	current_depth += 1
	
	bifurcate(node)
	current_nodes = node.children
	for child in node.children:
		bifurcate(child)
		
	focus_on_depth(node.graph_position)
	
	if node.parents.size() > 0:
		var seen = []
		for parent in node.parents:
			rec_graph_update(parent, seen)
	else:
		rec_graph_update(node)
	

func random_resource_type():
	var random_type = randi() % 3

	if random_type == 0:
		return "coin"
	elif random_type == 1:
		return "ruby"
	else:
		return "juice"


func rec_graph_find_by_pos(node, pos):
	if node.graph_position == pos:
		return node
	
	if node.children.size() == 0:
		return null
		
	for child in node.children:
		var n = rec_graph_find_by_pos(child, pos)
		if n != null:
			return n

func rec_graph_update(node, seen=[]):
	if seen.find(node) == -1:
		seen.append(node)
		node.graph_updated(self)
		for child in node.children:
			rec_graph_update(child, seen)


func shared_parent(nodes):
	var parents = []
	for node in nodes:
		for parent in node.parents:
			if parents.find(parent) != -1:
				return parent
			parents.append(parent)
	
	return null

	
func _on_node_clicked(node):
	if player.id != 0:
		return
		
	if self.current_nodes.find(node) == -1:
		return

	player_clicked.emit(node)
		
