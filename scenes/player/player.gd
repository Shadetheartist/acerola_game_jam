extends Node2D

signal added_resource(player, resource_node)
signal added_goblin(player)
signal yeeted(player)
signal paid(player, cost)

@export var id = 0


@export var resources = {
	'coin': 0,
	'ruby': 0,
	'juice': 0,
}

@export var max_resources = {
	'coin': 3,
	'ruby': 3,
	'juice': 3,
}

@export var ascension_level = 1
@export var health = 5
@export var goblin_count = 0
@export var max_goblin_count = 3

var costs = {
	'ascend' = {
		'coin': 3,
		'ruby': 3,
		'juice': 3,
	},
	'goblin' = {
		'coin': 2,
		'ruby': 0,
		'juice': 1,
	},
	'icbm' = {
		'coin': 15,
		'ruby': 15,
		'juice': 15,
	},
	'crypto' = {
		'coin': 1,
		'ruby': 0,
		'juice': 0,
	},
	'bury' = {
		'coin': 0,
		'ruby': 1,
		'juice': 0,
	},
	'yeet' = {
		'coin': 0,
		'ruby': 0,
		'juice': 1,
	},
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_sound_for_resource(type):
	if type == "coin":
		$CaChingPlayer.play()
	elif type == "ruby":
		$TaTingPlayer.play()
	elif type == "juice":
		$BaWingPlayer.play()


func _on_graph_player_clicked(node):
	if !node.is_ready():
		$BonkPlayer.play()
		return
		
	var type = node.resource_type
	
	if resources[type] >= max_resources[type]:
		$ErrPlayer.play()
		return
		
	resources[type] += 1
	
	play_sound_for_resource(type)
	
	added_resource.emit(self, node)
	
	$Graph.expand(node)


func _on_shop_buy(item, cost):
	# check if can pay the cost
	for r in costs[item]:
		if costs[item][r] > resources[r]:
			$ErrPlayer.play()
			return
	
	# actually pay the cost
	for r in costs[item]:
		resources[r] -= costs[item][r]
	
	paid.emit(self, costs[item])
	
	if item == 'ascend':
		$NicePlayer.play()
		ascension_level += 1
		
		var val = ascension_level * 3
		for r in max_resources:
			max_resources[r] = val
			costs['ascend'][r] = val
	
	elif item == 'goblin':
		
		if goblin_count < max_goblin_count:
			$GoblinPlayer.play()
			goblin_count += 1
			costs['goblin']['coin'] = 2 + goblin_count * 2
			costs['goblin']['ruby'] = goblin_count
			costs['goblin']['juice'] = 1 + goblin_count
			added_goblin.emit(self)
			
	elif item == 'icbm':
		$ICBMPlayer.play()

	elif item == 'crypto':
		$TinkPlayer.play()
	
	elif item == 'bury':
		$BuryPlayer.play()
		
	elif item == 'yeet':
		$YeetPlayer.play()
		yeeted.emit(self)












