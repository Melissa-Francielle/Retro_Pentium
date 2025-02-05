extends Control

signal animation_done

@onready var dialog_line = %DialogueRich
@onready var speaker_name = %NameLabel

const ANIMATION :  int = 30  
var animate_text : bool = false
var current_visible_characteres : int = 0 


func _ready():
	pass # Replace with function body.

func _process(delta):
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length())* (ANIMATION * delta)
			current_visible_characteres = dialog_line.visible_characters
			AudioController.play_character()
		else:
			animate_text = false
			animation_done.emit()
			
func change_line(speaker: String, line : String):
	speaker_name.text = speaker
	current_visible_characteres = 0
	dialog_line.text = line 
	dialog_line.visible_characters = 0 
	animate_text = true
	
func skip_text_animation():
	dialog_line.visible_ratio = 1
	
