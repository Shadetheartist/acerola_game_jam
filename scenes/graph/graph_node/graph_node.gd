extends Node2D

var player: Node

var resource_type = 'NOT_SET'

var ruby_viewport: SubViewport
var coin_viewport: SubViewport
var juice_viewport: SubViewport

signal clicked(node)

var graph_position: Vector2 = Vector2(0,0)
var parents = []
var children = []

var is_current = false
var is_old = false

@onready var ready_after = ready_after_calc()
@onready var ready_t = ready_after

var ready_color = Vector4(0,0.69,0,1)
var disabled_color = Vector4(0,0,0,0.33)
var hovered_color = Vector4(1,1,1,1)
var current_color = disabled_color
var is_hovered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_ready_t()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_ready():
		if is_current:
			ready_t -= delta
			
		$Circle.material.set_shader_parameter("color", disabled_color)
	else:
		if is_current:
			if is_hovered:
				$Circle.material.set_shader_parameter("color", hovered_color)
			else:
				$Circle.material.set_shader_parameter("color", current_color)
			
		

func update_visuals():
	if is_current:
		current_color = ready_color
	else:
		current_color = disabled_color
		
	$Circle.material.set_shader_parameter("color", current_color)
		
	if resource_type == "coin":
		$ResourceSprite.texture = coin_viewport.get_texture()
	elif resource_type == "ruby":
		$ResourceSprite.texture = ruby_viewport.get_texture()
	elif resource_type == "juice":
		$ResourceSprite.texture = juice_viewport.get_texture()


func ready_after_calc():
	if !player:
		return 1
		
	return max(0.15, 1 - (player.ascension_level-1) * 0.33)

func set_ready_t():
	if player:
		ready_after = ready_after_calc()
		ready_t = ready_after

func graph_updated(graph):
	is_current = graph.current_nodes.find(self) != -1
	is_old = graph_position.y <= graph.current_depth
	
	set_ready_t()
		
	update_visuals()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed:
			clicked.emit(self)


func _on_area_2d_mouse_entered():
	is_hovered = true

func _on_area_2d_mouse_exited():
	is_hovered = false
	
func is_ready():
	return ready_t <= 0
