extends Node3D

# Global

# Called when the node enters the scene tree for the first time.
func _ready():
	start_anim()
	show_win_text_after(14.0)
	restart_after(24.0)

func start_anim():
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.queue("open_lid")
	$AnimationPlayer.queue("launch")


func show_win_text_after(s):
	await get_tree().create_timer(s).timeout
	$Camera3D/WinLabel.visible = Global.winner_is_player
	$Camera3D/LoseLabel.visible = !Global.winner_is_player
	
func restart_after(s):
	await get_tree().create_timer(s).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")

var t = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera3D.look_at($ICBM.position)
	$SpotLight3D.visible = t < 1
	if t > 2:
		t = 0
		
	t += delta
	pass
