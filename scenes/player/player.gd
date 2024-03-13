extends Node2D

signal added_resource(player, resource_node)
signal added_goblin(player)
signal yeeted(player)
signal paid(player, cost)

@export var is_player = false

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
@export var max_ascension_level = 5

@export var health = 5
@export var goblin_count = 0
@export var max_goblin_count = 3

@export var ai_disabled = true

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


func _ready():
	if !is_player:
		opponent_action()


func _process(delta):
	pass


func opponent_action():
	
	if !is_inside_tree():
		print('not in tree???')
		return
	
	var t_wait = max(0.2, 1 - (ascension_level-1) * 0.25) + 0.33
	# wait for timeout
	await get_tree().create_timer(t_wait).timeout
	
	if ai_disabled == true:
		opponent_action()
		return
	
	var possible_actions = []
	
	# add actions for clickable nodes
	for graph_node in $Graph.current_nodes:
		if graph_node.is_ready():
			var r = graph_node.resource_type
			if resources[r] < max_resources[r]:
				possible_actions.append(['collect_resource_node', graph_node])
	
	# add shop actions
	for item in costs:
		if !can_afford(item, costs[item]):
			continue
			
		if item == 'goblin' && goblin_count >= max_goblin_count:
			continue
			
		if item == 'ascend' && ascension_level >= max_ascension_level:
			continue
			
		possible_actions.append(['buy_item', item, costs[item]])
	
	if possible_actions.size() < 1:
		push_error('opponent has nothing to do')
		opponent_action()
		return
	
	# action selection
	
	possible_actions.sort_custom(
		func(a, b):
			if a[0] == 'collect_resource_node':
				if b[0] == 'collect_resource_node':
					# A and B are both resource collection actions, A should be higher on the list
					# than B if there is less of A than B in the resource pool
					
					# adding some noise to this will make the AI less of a fuckin machine.
					var noise = 0
					if randi() % 2 == 0:
						noise = 3
					
					return resources[a[1].resource_type] + noise < resources[b[1].resource_type]
				else:
					# A is collecting a resource and B is buying from shop
					# A should be before B in the list normally
					return false
			elif a[0] == 'buy_item':
				if b[0] == 'buy_item':
					# A and B are both item buying actions
					
					# if A is dumping stock and B is dumping stock
					if is_dumping_stock(a[1]) && is_dumping_stock(b[1]):
						var resource_a = dumping_stock_resource(a[1])
						var resource_b = dumping_stock_resource(a[1])
						
						var a_is_maxed = resources[resource_a] == max_resources[resource_a]
						
						return a_is_maxed
					
					# always buy icbm when you can
					if a[1] == 'icbm':
						return false
					
					# ascend before goblin
					if a[1] == 'ascend' && b[1] == 'goblin':
						return false
						
					return false
				else:
					return false
	)

	
	# random
	# var selected_action = possible_actions[randi() % possible_actions.size()]
	
	var selected_action = possible_actions[0]
	
	print(selected_action)

	if selected_action[0] == 'collect_resource_node':
		var node = selected_action[1]
		_on_graph_player_clicked(node)
	elif selected_action[0] == 'buy_item':
		_on_shop_buy(selected_action[1], selected_action[2])
	
	# re-queue another action
	opponent_action()


func is_dumping_stock(item):
	return item == 'crypto' || item == 'bury' || item == 'yeet'


func dumping_stock_resource(item):
	if item == 'crypto': return 'coin'
	if item == 'bury': return 'ruby'
	if item == 'yeet': return 'juice'
	else: return 'the fuck'


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


func can_afford(item, cost):
	for r in costs[item]:
		if costs[item][r] > resources[r]:
			return false
			
	return true

func _on_shop_buy(item, cost):
	if !is_inside_tree():
		return

	# check if can pay the cost
	if !can_afford(item, cost):
		$ErrPlayer.play()
		return
		
	# actually pay the cost
	for r in costs[item]:
		resources[r] -= costs[item][r]
	
	paid.emit(self, costs[item])
	
	if item == 'ascend':
		if ascension_level >= max_ascension_level:
			# repay cost
			for r in costs[item]:
				resources[r] += costs[item][r]
			$ErrPlayer.play()
			return
		
		$NicePlayer.play()
		ascension_level += 1
		
		var val = ascension_level * 3
		for r in max_resources:
			max_resources[r] = val
			costs['ascend'][r] = val
	
	elif item == 'goblin':
		
		if goblin_count >= max_goblin_count:
			# repay cost
			for r in costs[item]:
				resources[r] += costs[item][r]
			$ErrPlayer.play()
			return
			
		$GoblinPlayer.play()
		goblin_count += 1
		costs['goblin']['coin'] = 2 + goblin_count * 2
		costs['goblin']['ruby'] = goblin_count
		costs['goblin']['juice'] = 1 + goblin_count
		added_goblin.emit(self)
			
	elif item == 'icbm':
		go_to_silo()

	elif item == 'crypto':
		$TinkPlayer.play()
	
	elif item == 'bury':
		$BuryPlayer.play()
		
	elif item == 'yeet':
		$YeetPlayer.play()
		yeeted.emit(self)


func go_to_silo():
	Global.winner_is_player = is_player
	get_tree().change_scene_to_file("res://scenes/silo/silo.tscn")


func _on_goblin_bite():
	var resources_we_have = []
	for r in resources:
		if resources[r] > 0:
			resources_we_have.append(r)
	
	if resources_we_have.size() == 0:
		return
	
	var r_idx = randi() % resources_we_have.size()
	var r_resource_type = resources_we_have[r_idx]
	
	var cost = {
		'coin': 0,
		'ruby': 0,
		'juice': 0,
	}
	cost[r_resource_type] = 1
	resources[r_resource_type] -= 1
	
	paid.emit(self, cost)
	
