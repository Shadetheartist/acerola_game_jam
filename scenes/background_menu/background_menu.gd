extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.queue("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CameraBase.rotate(Vector3(0, 1, 0), delta/5)
	pass
