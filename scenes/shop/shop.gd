extends Node2D

signal buy(item, cost)

@export var player: Node
@onready var coin_progress_bar = find_child("CoinProgressBar")
@onready var ruby_progress_bar = find_child("RubyProgressBar")
@onready var juice_progress_bar = find_child("JuiceProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Ascend, 
		'ascend', 
		"Ascend " + str(player.ascension_level + 1)
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Goblin, 
		'goblin', 
		"Goblin " + str(player.goblin_count + 1)
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/ICBM, 
		'icbm', 
		"ICBM"
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Crypto, 
		'crypto', 
		"Buy Crypto"
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Bury, 
		'bury', 
		"Bury"
	)
	
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Yeet, 
		'yeet', 
		"Yeet"
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin_progress_bar.value = (float(player.resources['coin']) / player.max_resources['coin']) * 100
	ruby_progress_bar.value = (float(player.resources['ruby']) / player.max_resources['ruby']) * 100
	juice_progress_bar.value = (float(player.resources['juice']) / player.max_resources['juice']) * 100
	
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/CoinProgressBar/CoinNum.text = str(player.resources['coin'])
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/RubyProgressBar/RubyNum.text = str(player.resources['ruby'])
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer3/JuiceProgressBar/JuiceNum.text = str(player.resources['juice'])
	

func update_shop_item(node, type, label):
	node.label = label
	node.cost_coin = player.costs[type]['coin']
	node.cost_ruby = player.costs[type]['ruby']
	node.cost_juice = player.costs[type]['juice']
	node.update()


func _on_ascend_clicked(cost_arr):
	buy.emit('ascend', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Ascend, 
		'ascend', 
		"Ascend " + str(player.ascension_level + 1)
	)


func _on_goblin_clicked(cost_arr):
	buy.emit('goblin', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Goblin, 
		'goblin', 
		"Goblin " + str(player.goblin_count + 1)
	)


func _on_icbm_clicked(cost_arr):
	buy.emit('icbm', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/ICBM, 
		'icbm', 
		"ICBM"
	)
	
	
func _on_crypto_clicked(cost_arr):
	buy.emit('crypto', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Crypto, 
		'crypto', 
		"Buy Crypto"
	)


func _on_bury_clicked(cost_arr):
	buy.emit('bury', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Bury, 
		'bury', 
		"Bury"
	)


func _on_yeet_clicked(cost_arr):
	buy.emit('yeet', cost_arr)
	update_shop_item(
		$HBoxContainer/MarginContainer2/GridContainer/Yeet, 
		'yeet', 
		"Yeet"
	)
