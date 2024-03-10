extends Node3D

var juice_scene = preload("res://scenes/resources/juice/item/juice_item.tscn")

@onready var initial_fov = $Camera3D.fov
@onready var initial_pos = $Camera3D.position
# Called when the node enters the scene tree for the first time.
func _ready():
	$JuiceSpawn.look_at($JuiceTarget.position)


var t = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	$Camera3D.fov = initial_fov + sin(t / 10) * 10
	$Camera3D.position = initial_pos + Vector3(sin(t / 10), 0, 0)
	$Camera3D.look_at($LookTarget.position)


func yeet_juice():
	var item = juice_scene.instantiate()
	item.position = $JuiceSpawn.position
	item.rotation = Vector3(randi() % 3, randi() % 3, randi() % 3)
	item.linear_velocity = $JuiceSpawn.get_global_transform().basis.z * - ((randi() % 10) + 10)
	
	add_child(item)
