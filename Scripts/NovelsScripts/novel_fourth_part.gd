extends Node2D

var game_scene = preload("res://Scenes/world.tscn")
@onready var fade_rect = $Fade/FadeRect
@onready var animation_player = $BackgroundFourth/KodoAnimation  # Referência à animação

func _ready():
	fade_rect.modulate.a = 1  # Começa com a tela preta
	AudioController.play_cutscene()
	start_fade_in()

func start_fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5)  # Fade-in em 1.5s
	await tween.finished
	animation_player.play("KodoAnimation")  # Começa a cutscene
	await animation_player.animation_finished  # Espera a animação terminar
	start_fade_out()

func start_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)  # Fade-out em 1.5s
	await tween.finished
	load_next_scene()

func load_next_scene():
	get_tree().change_scene_to_packed(game_scene)

