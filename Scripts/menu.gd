extends Node



# Chamado quando o nó entra na árvore de cena pela primeira vez.
func _ready() -> void:
	# Conecta o sinal "pressed" do botão ao método "_carregar_jogo".
	$Arquivo.pressed.connect(_carregar_jogo)

func _carregar_jogo() -> void:
	# Muda para a cena especificada.
	get_tree().change_scene_to_file("res://Scenes/menu_secundario.tscn")
