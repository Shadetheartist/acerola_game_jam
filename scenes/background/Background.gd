extends Node3D

signal goblin_bite_player
signal goblin_bite_opponent

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


func _on_item_spawner_goblin_bite_player():
	goblin_bite_player.emit()


func _on_item_spawner_2_goblin_bite_opponent():
	goblin_bite_opponent.emit()
