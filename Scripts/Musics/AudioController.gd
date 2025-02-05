extends Node2D

@export var mute : bool = false 

func _ready():
	pass
		
func play_menu():
	if not mute:
		$Menu.play()
		
func play_cutscene() -> void:
	if not mute:
		$Menu.stop()
		$Song.play()
		
func play_jump() -> void:
	if not mute:
		$Jump.play()


func play_end_level() -> void:
	if not mute:
		$Song.stop()
		$EndLevel.play()

func play_end_leve_win() -> void:
	if not mute:
		$Song.stop()
		$EndLevel2.play()
	
func play_character():
	if not mute:
		$Character.play()

func play_wrong() -> void:
	if not mute:
		$Wrong.play()
		
func play_right() -> void:
	if not mute:
		$Right.play()
