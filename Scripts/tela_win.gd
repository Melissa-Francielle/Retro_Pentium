extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("winScene")
	$AnimatedSprite2D.play("continuosWin")
	AudioController.play_end_leve_win()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
