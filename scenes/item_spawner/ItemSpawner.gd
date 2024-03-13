extends Node3D


signal goblin_bite

var coin_scene = preload("res://scenes/resources/coin/item/coin_item.tscn")
var ruby_scene = preload("res://scenes/resources/ruby/item/ruby_item.tscn")
var juice_scene = preload("res://scenes/resources/juice/item/juice_item.tscn")

var spawn_queue = []

@export var resource_nodes = {
	'coin': [],
	'ruby': [],
	'juice': [],
}

@export var goblin_count = 0
var max_goblins = 3
var goblin_cds = [0.0, 0.0, 0.0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0
var cd = 0.25
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t > cd && spawn_queue.size() > 0:
		var item = spawn_queue.pop_front()
		if is_instance_valid(item):
			self.get_parent().add_child(item)
			freeze_node_after(item, 3.0)
		t = 0
	
	# lmao, programming over a decade and i still do this shit sometimes (its faster rn)
	if goblin_count >= 1:
		goblin_cds[0] += delta
		if goblin_cds[0] >= 11:
			goblin_cds[0] = 0
			$Goblin1.start_bite_anim()
		
	if goblin_count >= 2:
		goblin_cds[1] += delta
		if goblin_cds[1] >= 11:
			goblin_cds[1] = 0
			$Goblin2.start_bite_anim()
		
	if goblin_count >= 3:
		goblin_cds[2] += delta
		if goblin_cds[2] >= 11:
			goblin_cds[2] = 0
			$Goblin3.start_bite_anim()


func freeze_node_after(node, s):
	await get_tree().create_timer(s).timeout
	if is_instance_valid(node):
		node.freeze = true

func spawn_by_resource_type(resource_type):
	if resource_type == "coin":
		spawn_coin()
	elif resource_type == "ruby":
		spawn_ruby()
	elif resource_type == "juice":
		spawn_juice()

func spawn_item(type, scene):
	var item = scene.instantiate()
	item.name = type + '@' + str(randi())
	item.position = self.position
	item.rotation = Vector3(randi() % 3, randi() % 3, randi() % 3)
	spawn_queue.append(item)
	resource_nodes[type].append(item)
	
	
func spawn_coin():
	spawn_item('coin', coin_scene)
	
func spawn_ruby():
	spawn_item('ruby', ruby_scene)
	
func spawn_juice():
	spawn_item('juice', juice_scene)
	
func remove_goblin():
	if goblin_count < 1:
		return
	
	var goblin_node_name = "Goblin" + str(goblin_count)
	var goblin_node = find_child(goblin_node_name)
	if goblin_node:
		goblin_node.disable()
		goblin_count -= 1
	else:
		push_error("couldn't find goblin node " + goblin_node_name)
	
func burn_resource(type):
	if resource_nodes[type].size() < 1:
		return
		
	var item = resource_nodes[type].pop_back()
	item.queue_free()
	
func add_goblin():
	if goblin_count >= max_goblins:
		return
		
	goblin_count += 1
	var goblin_node_name = "Goblin" + str(goblin_count)
	var goblin_node = find_child(goblin_node_name)
	if goblin_node:
		goblin_node.enable()
	else:
		push_error("couldn't find goblin node " + goblin_node_name)


func _on_goblin_bite(gobbo):
	goblin_bite.emit()
