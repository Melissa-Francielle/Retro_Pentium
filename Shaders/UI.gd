extends Control

@onready var texture_rect = $TextureRect

@export var gradient : Gradient 

var min_health = 0.0
var max_health = 100.0

var health: float = max_health:
	set(value):
		health = clamp(value, min_health, max_health)
		
func _ready():
	texture_rect.modulate = gradient.sample(health / max_health)
	
func _input(event):
	if event.is_action_pressed("move_up") && event.pressed:
		health += 5
		texture_rect.scale.x = (health / max_health)
		texture_rect.modulate = gradient.sample(health / max_health)
	elif event.is_action_pressed("move_down") && event.pressed:
		health -= 5 
		texture_rect.scale.x = (health / max_health)
		texture_rect.modulate = gradient.sample(health / max_health)

