extends Node

@export var id = 0

@export var max_coin = 3
@export var num_coin = 0

@export var max_ruby = 3
@export var num_ruby = 0

@export var max_juice = 3
@export var num_juice = 0

@export var ascension_level = 1
@export var health = 5

# track created resources so we can burn them later
var resource_nodes = {
	'coin': [],
	'ruby': [],
	'juice': [],
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_resources():
	return [
		num_coin,
		num_ruby,
		num_juice
	]
	
func max_resources():
	return [
		max_coin,
		max_ruby,
		max_juice
	]


func set_resources(resources):
	if resources[0] > max_coin:
		return false
	
	if resources[1] > max_ruby:
		return false
	
	if resources[2] > max_juice:
		return false
		
	num_coin = resources[0]
	num_ruby = resources[1]
	num_juice = resources[2]
	
	return true
