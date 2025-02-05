extends CanvasLayer

@onready var menu = $overlay/pause_menu/menu
@onready var resume = $overlay/pause_menu/continue
@onready var animator = $animator
func _ready():
	visible = false 
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		animator.play("pause_animation")
		get_tree().paused = true 
		resume.grab_focus()


func _on_heart_pressed():
	$overlay/pause_menu/heart/heatAnimation.visible = true
	$overlay/pause_menu/heart/heatAnimation.play("heart")
	pass # Replace with function body.


func _on_continue_pressed():
	animator.play("resume_game")
	get_tree().paused = false
	await animator.animation_finished
	visible = false

func _on_menu_pressed():
	get_tree().quit()
