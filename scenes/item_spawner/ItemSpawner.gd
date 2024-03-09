extends Node3D

var coin_scene = preload("res://scenes/resources/coin/item/coin_item.tscn")
var ruby_scene = preload("res://scenes/resources/ruby/item/ruby_item.tscn")
var juice_scene = preload("res://scenes/resources/juice/item/juice_item.tscn")

var spawn_queue = []

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
		self.get_parent().add_child.call_deferred(item)
		get_tree().create_timer(3.0).timeout.connect(func(): item.freeze = true)
		t = 0


func spawn_item(scene):
	var item = scene.instantiate()
	item.position = self.position
	item.rotation = Vector3(randi() % 3, randi() % 3, randi() % 3)
	spawn_queue.append(item)
	
	
func spawn_coin():
	spawn_item(coin_scene)
	
func spawn_ruby():
	spawn_item(ruby_scene)
	
func spawn_juice():
	spawn_item(juice_scene)
	
	
