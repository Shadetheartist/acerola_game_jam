extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	$ruby.rotate_object_local(Vector3(sin(t / 2), cos(t / 2), 0), delta)
