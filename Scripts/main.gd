extends Node2D

@export var health = 10

var current_scene: Node2D

@onready var current_viewport = $CurrentLevel


func new_scene(scene: Resource):
	var object = scene.instantiate()
	current_scene = object
	current_scene.died.connect(die)
	current_scene.completed_level.connect(current_won)
	current_viewport.add_child(current_scene)

func current_won():
	print('Yay won')
	new_scene(current_scene.next)
	
func die():
	print('Aw, I died :(')
	_ready()
	

func _ready() -> void:
	var intro_level_scene = preload("res://Scenes/Levels/Intro/1.tscn")
	new_scene(intro_level_scene)
