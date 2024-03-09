extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	var v = self.linear_velocity.length()
	if v > 1.4:
		$TinkPlayer.volume_db = 0 - 30 / v 
		$TinkPlayer.play()
