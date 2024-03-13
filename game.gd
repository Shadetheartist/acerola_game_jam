extends Node2D

var opponent_view_scene = preload("res://scenes/opponent_view/opponent_view.tscn")



var viewport_initial_size = Vector2()
@onready var viewport = $SubViewport
@onready var viewport_sprite = $ViewportSprite

@export_enum("none", "copycat", "contrarian", "ai_random") var ai_strategy = "ai_random"

@onready var player_item_spawner = $SubViewport/Background/ItemSpawner
@onready var opponent_item_spawner = $SubViewport/Background/ItemSpawner2

# Called when the node enters the scene tree for the first time.
func _ready():
	# hamstring the player in the tutorial
	if Global.show_tutorial:
		$Tutorial.visible = true
		$Tutorial/Part1.visible = true
		$Tutorial/Part2.visible = false
		$Tutorial/Part3.visible = false
		$Tutorial/Part4.visible = false
		$Player.max_resources['coin'] = 1
		$Player.max_resources['ruby'] = 1
		$Player.max_resources['juice'] = 1
		Global.show_tutorial = false
	else:
		finish_tutorial()
		
	get_viewport().connect("size_changed", Callable(self, "_root_viewport_size_changed"))
	viewport_initial_size = viewport.size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_in_tutorial():
		var c = 0
		for r in $Player.resources:
			c += $Player.resources[r]
		
		$Tutorial/Part2/TutorialP2Button.disabled = c != 0
		$Tutorial/Part2/TossLabel.visible = c != 0
		

# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	viewport.size = Vector2.ONE * get_viewport().size.y
	viewport_sprite.scale = Vector2(1, -1) * viewport_initial_size.y / get_viewport().size.y


func _on_player_added_resource(player, resource_node):
	player_item_spawner.spawn_by_resource_type(resource_node.resource_type)


func _on_player_added_goblin(player):
	opponent_item_spawner.add_goblin()


func _on_player_yeeted(player):
	$OpponentViewport/OpponentView.yeet_juice()


func _on_player_paid(player, cost):
	for r in cost:
		for n in range(0, cost[r]):
			player_item_spawner.burn_resource(r)


func _on_opponent_added_resource(player, resource_node):
	opponent_item_spawner.spawn_by_resource_type(resource_node.resource_type)


func _on_opponent_added_goblin(player):
	player_item_spawner.add_goblin()


func _on_opponent_paid(player, cost):
	for r in cost:
		for n in range(0, cost[r]):
			opponent_item_spawner.burn_resource(r)


func _on_opponent_yeeted(player):
	pass # Replace with function body.


func is_in_tutorial():
	return $Tutorial.visible

func finish_tutorial():
	$Tutorial.visible = false
	$Opponent.ai_disabled = false
	$Player.max_resources['coin'] = 3
	$Player.max_resources['ruby'] = 3
	$Player.max_resources['juice'] = 3

func _on_tutorial_p_1_button_pressed():
	$Tutorial/Part1.visible = false
	$Tutorial/Part2.visible = true


func _on_tutorial_p_2_button_pressed():
	$Tutorial/Part2.visible = false
	$Tutorial/Part3.visible = true


func _on_tutorial_p_3_button_pressed():
	$Tutorial/Part3.visible = false
	$Tutorial/Part4.visible = true


func _on_tutorial_p_4_button_pressed():
	finish_tutorial()
