extends HBoxContainer

signal clicked

@export var label = 'Item'
@export var image = Texture2D
@export var image_hover = Texture2D
@export var image_click = Texture2D

@export var cost_coin = 0
@export var cost_ruby = 0
@export var cost_juice = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
	$TextureButton.texture_normal = image
	$TextureButton.texture_hover = image_hover
	$TextureButton.texture_pressed = image_click


func update():
	$VBoxContainer/ItemLabel.text = label
	$VBoxContainer/HBoxContainer/CoinCost/CoinCostLabel.text = str(cost_coin)
	$VBoxContainer/HBoxContainer/RubyCost/RubyCostLabel.text = str(cost_ruby)
	$VBoxContainer/HBoxContainer/JuiceCost/JuiceCostLabel.text = str(cost_juice)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	clicked.emit([cost_coin, cost_ruby, cost_juice])
