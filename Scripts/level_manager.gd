class_name Level
extends Node2D


@export var next: Resource = preload("res://Scenes/Levels/LevelManager.tscn")

var player = preload("res://Scenes/Player.tscn")

signal died
signal completed_level
signal got_checkpoint

func on_player_collision(player: Player, collision: Node2D) -> void:	
	if collision == $Spinners: # Spikes! ow ow ow
		print('Owie, zowie')
		died.emit()
	elif collision == $Checkpoint:
		print('Yay, I\'m safer')
		got_checkpoint.emit()
	elif collision == $Goal:
		print('Oh hi I won')
		remove_child(player)
		completed_level.emit()


func _ready() -> void:
	$Player.collided.connect(on_player_collision)
