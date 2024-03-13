extends Node2D

signal buy(item, cost)

@export var player: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/ResourceBars.player = player
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Ascend, 
		'ascend', 
		"Ascend " + str(player.ascension_level + 1),
		false
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Goblin, 
		'goblin', 
		"Goblin " + str(player.goblin_count + 1),
		false
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/ICBM, 
		'icbm', 
		"ICBM",
		false
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Crypto, 
		'crypto', 
		"Buy Crypto",
		false
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Bury, 
		'bury', 
		"Bury",
		false
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Yeet, 
		'yeet', 
		"Yeet",
		false
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_shop_item(node, type, label, disable):
	node.label = label
	node.cost_coin = player.costs[type]['coin']
	node.cost_ruby = player.costs[type]['ruby']
	node.cost_juice = player.costs[type]['juice']
	
	if disable:
		node.disable()
	
	node.update()


func _on_ascend_clicked(cost_arr):
	buy.emit('ascend', cost_arr)
	var name = "Ascend " + str(player.ascension_level + 1)
	var disable = player.ascension_level >= player.max_ascension_level
	if disable:
		name = "MAXED"
		
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Ascend, 
		'ascend', 
		name,
		disable
	)


func _on_goblin_clicked(cost_arr):
	buy.emit('goblin', cost_arr)
	var name = "Goblin " + str(player.goblin_count + 1)
	var disable = player.goblin_count >= player.max_goblin_count
	if disable:
		name = "MAXED"
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Goblin, 
		'goblin', 
		name,
		disable
	)


func _on_icbm_clicked(cost_arr):
	buy.emit('icbm', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/ICBM, 
		'icbm', 
		"ICBM",
		false
	)
	
	
func _on_crypto_clicked(cost_arr):
	buy.emit('crypto', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Crypto, 
		'crypto', 
		"Buy Crypto",
		false
	)


func _on_bury_clicked(cost_arr):
	buy.emit('bury', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Bury, 
		'bury', 
		"Bury",
		false
	)


func _on_yeet_clicked(cost_arr):
	buy.emit('yeet', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Yeet, 
		'yeet', 
		"Yeet",
		false
	)
