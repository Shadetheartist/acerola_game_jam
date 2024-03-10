extends Node3D

@onready var initial_pos = self.position
@onready var target_pos = self.position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, target_pos, 0.1)
	pass


func enable():
	visible = true
	position = initial_pos - Vector3(0, 1, 0)
	target_pos = initial_pos
	
func disable():
	toggle_visible_after(1)
	target_pos = initial_pos - Vector3(0, 1, 0)

func toggle_visible_after(s):
	await get_tree().create_timer(s).timeout
	visible = false
