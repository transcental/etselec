extends Node2D

@export var health = 10

var current_scene: Node2D

@onready var current_viewport_container = $CurrentLevelContainer
@onready var current_viewport = $CurrentLevelContainer/CurrentLevel
@onready var window: Window = get_window()


signal new_death

func new_scene(scene: Resource):
	current_viewport.remove_child(current_scene)
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
	new_death.emit()


func _ready() -> void:
	var intro_level_scene = preload("res://Scenes/Levels/Intro/1.tscn")
	new_scene(intro_level_scene)
