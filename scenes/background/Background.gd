extends Node3D

@onready var ab_init_pos = $abberation.position
@onready var ab_init_rot = $abberation.rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0
func _process(delta):
	t += delta
	
	$abberation.position = ab_init_pos + Vector3(0, cos(t) * cos(t) * 0.01 , 0)
	$abberation.rotation = ab_init_rot + Vector3(0, cos(t) * 0.16, 0)
	pass
