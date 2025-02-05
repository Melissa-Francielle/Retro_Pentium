extends Area2D

var show = false
var ativada = false  

@onready var world = get_tree().current_scene  # Obtém a referência ao mundo

func _ready():
	$AnimatedSprite2D/AnimationPlayer.play("idle")  

func _process(delta):
	$press.visible = show  

	if show and Input.is_action_just_pressed("interact") and not ativada:
		ativar_alavanca()

func ativar_alavanca():
	ativada = true  
	$AnimatedSprite2D/AnimationPlayer.play("ativo")  
	await $AnimatedSprite2D/AnimationPlayer.animation_finished  

	await get_tree().create_timer(2.0).timeout  

	$AnimatedSprite2D/AnimationPlayer.play("desativado")  
	await $AnimatedSprite2D/AnimationPlayer.animation_finished  
	$AnimatedSprite2D/AnimationPlayer.play("idle")  

	world.reativar_blocos()  # Chama a função no World para reativar os blocos
	ativada = false  

func _on_body_entered(body):
	if body is CharacterBody2D:
		show = true  

func _on_body_exited(body):
	if body is CharacterBody2D:
		show = false  
