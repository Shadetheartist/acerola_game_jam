extends Node2D

var opponent_view_scene = preload("res://scenes/opponent_view/opponent_view.tscn")

var viewport_initial_size = Vector2()
@onready var viewport = $SubViewport
@onready var viewport_sprite = $ViewportSprite

@export_enum("none", "copycat", "contrarian", "ai_random") var ai_strategy = "ai_random"

var ai_action_timer = null
var ai_action_period_s = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().connect("size_changed", Callable(self, "_root_viewport_size_changed"))
	viewport_initial_size = viewport.size
	if ai_strategy == "ai_random":
		ai_action_timer = get_tree().create_timer(ai_action_period_s)
		ai_action_timer.timeout.connect(ai_random_action)
		
	$Graph.item_spawner = $SubViewport/Background/ItemSpawner
	$Graph2.item_spawner = $SubViewport/Background/ItemSpawner2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
	
func ai_random_action():
	var buy = randi() % 4
	
	if buy == 0:
		pass
	else:
		var r = randi() % $Graph2.current_nodes.size()
		var node = $Graph2.current_nodes[r]
		$Graph2.expand(node)
	
	if ai_strategy == "ai_random":
		ai_action_timer = get_tree().create_timer(ai_action_period_s)
		ai_action_timer.timeout.connect(ai_random_action)
	

func _on_graph_player_clicked(node, result):
	if !result:
		$ErrPlayer.play()
		return
	
	if node.resource_type == 0:
		$CaChingPlayer.play()
	elif node.resource_type == 1:
		$TaTingPlayer.play()
	elif node.resource_type == 2:
		$BaWingPlayer.play()
			
	
	if ai_strategy == "none":
		return
		
	if ai_strategy == "ai_random":
		return
	
	var name = null
	if ai_strategy == "copycat":
		name = node.name
	elif ai_strategy == "contrarian": 
		var corresponding_position = node.graph_position * Vector2(-1, 1)
		name = $Graph.generate_name(corresponding_position)

	var corresponding_node = $Graph2/RootNode.find_child(name, true, false)
	if corresponding_node:
		$Graph2.expand(corresponding_node)

	

# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	viewport.size = Vector2.ONE * get_viewport().size.y
	viewport_sprite.scale = Vector2(1, -1) * viewport_initial_size.y / get_viewport().size.y
