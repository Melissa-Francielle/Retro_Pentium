extends Node2D

@onready var character = %CharacterScene
@onready var dialog_ui = %DialogueUI
@onready var fade_rect = $Fade/FadeRect

var dialog_index : int = 0
var fourth = preload("res://NovelsScenes/novel_fourth_part.tscn")

const dialog_lines : Array[String] = [
	"Renkai: 	Ele se distrai com facilidade...",
	"Oko: 	Não consigo entender como confiaram nele para lidar com algo tão importante.",
]

func _ready():
	$BackgroundThird/AnimatedSprite2D.play("BackgroundThird")
	dialog_index = 0
	fade_rect.modulate.a = 0
	process_curret_line()
	pass 
	
func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1:
				dialog_index += 1
				process_curret_line()
			else:
				start_fade_out()
	pass

func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return{
		"speaker_name": line_info[0],
		"dialog_line": line_info[1]
	}
	pass
	
func process_curret_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	#dialog_ui.speaker_name.text = line_info["speaker_name"]
	#dialog_ui.dialog_line.text = line_info["dialog_line"]
	dialog_ui.change_line(line_info["speaker_name"], line_info["dialog_line"])
	character.change_character(line_info["speaker_name"])
	pass

func start_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	await tween.finished
	load_next_cutscene()

func load_next_cutscene():
	get_tree().change_scene_to_packed(fourth)
