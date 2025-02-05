extends ProgressBar

var min_health = 0.0
var max_health = 100.0
var health: float = max_health:
	set(value):
		health = clamp(value, min_health, max_health)  # Garante que não passe de 100 ou vá abaixo de 0
		value = health
		atualizar_barra()

func _ready():
	atualizar_barra()

func atualizar_barra():
	self.value = health  # Atualiza o valor do ProgressBar

func reduzir_vida(perda):
	health -= perda
	atualizar_barra()

	# Se a vida chegar a 0, máquina quebra -> Game Over
	if health <= 0:
		print("A MÁQUINA QUEBROU! GAME OVER!")
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")  # Troque pelo nome da sua cena de game over
