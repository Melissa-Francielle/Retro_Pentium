extends Node

# Chamado quando o nó entra na árvore de cena pela primeira vez.
func _ready() -> void:
	# Define o AnimatedSprite2D como visível e executa a animação "Menu".
	$Sprite2D/AnimatedSprite2D.play("menu")
	AudioController.play_menu()
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://NovelsScenes/novel_part_one.tscn")
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
