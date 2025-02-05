extends Node2D

@onready var animated_sprite = $Character

const CHARACTER = {
	"Terry": preload("res://NovelsScenes/characters/Terry.tres"),
	"Oko": preload("res://NovelsScenes/characters/oko.tres"),
	"Renkai": preload("res://NovelsScenes/characters/renkai.tres"),
	"Kodo": preload("res://NovelsScenes/characters/Kodo.tres")
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_character(character_name : String, is_talking : bool = true):
	animated_sprite.sprite_frames = CHARACTER[character_name]
	if is_talking:
		animated_sprite.play("talking")
