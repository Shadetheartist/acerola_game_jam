extends Node2D

# RT-2PM2 <<Topol-M>> cold-launched three-stage solid-propellant silo-based intercontinental ballistic missile

signal buy

@export var player: Node
@onready var coin_progress_bar = find_child("CoinProgressBar")
@onready var ruby_progress_bar = find_child("RubyProgressBar")
@onready var juice_progress_bar = find_child("JuiceProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin_progress_bar.value = (float(player.num_coin) / player.max_coin) * 100
	ruby_progress_bar.value = (float(player.num_ruby) / player.max_ruby) * 100
	juice_progress_bar.value = (float(player.num_juice) / player.max_juice) * 100
	
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/CoinProgressBar/CoinNum.text = str(player.num_coin)
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/RubyProgressBar/RubyNum.text = str(player.num_ruby)
	$HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer3/JuiceProgressBar/JuiceNum.text = str(player.num_juice)
	
	
func pay_cost(cost_arr):
	if player.num_coin < cost_arr[0] || player.num_ruby < cost_arr[1] || player.num_juice < cost_arr[2]:
		return false
		
	player.num_coin -= cost_arr[0]
	player.num_ruby -= cost_arr[1]
	player.num_juice -= cost_arr[2]

	return true

func _on_ascend_clicked(cost_arr):
	
	if !pay_cost(cost_arr):
		$BonkPlayer.play()
		return
		
	$NicePlayer.play()
	
	player.ascension_level += 1
	
	var val = player.ascension_level * 3
	
	player.max_coin = val
	player.max_ruby = val
	player.max_juice = val
	
	var ascend = $HBoxContainer/MarginContainer2/GridContainer/Ascend
	
	ascend.cost_coin = val
	ascend.cost_ruby = val
	ascend.cost_juice = val
	
	ascend.label = "Ascend " + str(player.ascension_level)
	ascend.update()
	
	buy.emit('ascend', cost_arr)
	


func _on_goblin_clicked(cost_arr):
	if !pay_cost(cost_arr):
		$BonkPlayer.play()
		return
		
	$GoblinPlayer.play()
	
	buy.emit('goblin', cost_arr)
		
	

func _on_icbm_clicked(cost_arr):
	if !pay_cost(cost_arr):
		$BonkPlayer.play()
		return
		
	$ICBMPlayer.play()
	
	buy.emit('icbm', cost_arr)
