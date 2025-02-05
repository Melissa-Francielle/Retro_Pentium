extends Node

@onready var botao_tentar_novamente = $AnimatedSprite2D/GameOver/Yes
@onready var botao_voltar_menu = $AnimatedSprite2D/GameOver/Nao

func _ready():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("gameOver")
	AudioController.play_end_level()
	botao_tentar_novamente.connect("pressed", _on_tentar_novamente_pressionado)
	botao_voltar_menu.connect("pressed", _on_voltar_menu)

func _on_tentar_novamente_pressionado():
	print("Botão de tentar novamente pressionado!")  # Debug
	# Reinicia os dados do jogo sem recarregar a cena
	get_tree().paused = false  # Caso o jogo tenha sido pausado no game over
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	queue_free()  # Fecha a tela de game over

func _on_voltar_menu():
	get_tree().change_scene_to_file("res://Scenes/menu_secundario.tscn")
	queue_free()  # Fecha a tela de game over
