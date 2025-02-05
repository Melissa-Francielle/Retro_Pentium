extends StaticBody2D

@export var gravity: float = 2925.0
@export var initial_bounce: float = -240.0

@onready var world = get_tree().current_scene
@onready var bounce_timer: Timer = $BounceTime
@onready var sprite: Sprite2D = $Sprite2D

var y: float = 0.0 
var y_original: float 
var ativo = true  

func _ready():
	y_original = sprite.position.y
	add_to_group("escalonamento_blocos")  

func _process(delta: float):
	if bounce_timer.is_stopped():
		sprite.position.y = y_original
		y = 0.0 
	else:
		sprite.position.y += y * delta
		y += gravity * delta 

func _bounce():
	y = initial_bounce
	bounce_timer.start()

func _on_area_2d_area_entered(area):
	if area is Area2D and ativo:
		_bounce()
		world.aplicar_escalonamento(self.name)

func desativar_bloco():
	ativo = false
	modulate = Color(0.5, 0.5, 0.5, 1)

func ativar_bloco():
	ativo = true
	modulate = Color(1, 1, 1, 1)  # Volta à cor normal
