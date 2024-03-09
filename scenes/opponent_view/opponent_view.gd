extends Node3D

@onready var initial_fov = $Camera3D.fov
@onready var initial_pos = $Camera3D.position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var t = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	$Camera3D.fov = initial_fov + sin(t / 10) * 10
	$Camera3D.position = initial_pos + Vector3(sin(t / 10), 0, 0)
	$Camera3D.look_at($LookTarget.position)
