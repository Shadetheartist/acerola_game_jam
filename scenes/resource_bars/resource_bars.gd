extends MarginContainer

@export var player: Node

@onready var coin_progress_bar = find_child("CoinProgressBar")
@onready var ruby_progress_bar = find_child("RubyProgressBar")
@onready var juice_progress_bar = find_child("JuiceProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin_progress_bar.value = (float(player.resources['coin']) / player.max_resources['coin']) * 100
	ruby_progress_bar.value = (float(player.resources['ruby']) / player.max_resources['ruby']) * 100
	juice_progress_bar.value = (float(player.resources['juice']) / player.max_resources['juice']) * 100
	
	$HBoxContainer/VBoxContainer/CoinProgressBar/CoinNum.text = str(player.resources['coin'])
	$HBoxContainer/VBoxContainer2/RubyProgressBar/RubyNum.text = str(player.resources['ruby'])
	$HBoxContainer/VBoxContainer3/JuiceProgressBar/JuiceNum.text = str(player.resources['juice'])
	
