class_name Player
extends CharacterBody2D

@export var speed = 175.0
@export var gravity = 300
@export var jump_height = -145
@export var acceleration = 10
@export var dash_speed = 400  # Example value for dashing

signal collided(player: Player, event: Node2D)

var is_dashing = false
var is_climbing = false
var is_jumping = false
var fast_falling = false
var jump_strength = 0
var current_anim
var checkpoint = null

func _ready():
	checkpoint = self.global_position
	print('checkpoint', checkpoint)

func horizontal_movement():
	var hor_inp = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	self.velocity.x = hor_inp * speed

func _physics_process(delta: float) -> void:
	var grounded = self.is_on_floor()
#
	# Handle gravity
	if not grounded:
		self.velocity.y += gravity * delta
#
	horizontal_movement()
#
	# Jump handling
	if is_jumping and grounded:
		self.velocity.y = jump_height  # Set jump velocity immediately
		is_jumping = false
#
	# Apply movement
	self.move_and_slide()

	# Apply animations
	if not is_climbing:
		player_animations()

	if not grounded and fast_falling:
		self.velocity.y += gravity * 2 * delta  # Faster falling when holding down
		
	for body in $Area2D.get_overlapping_bodies():
		collided.emit(self, body)



func player_animations():
	if is_climbing:
		current_anim = "climb"
		$AnimatedSprite2D.play("climb")
		return

	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
		current_anim = "run"
		$AnimatedSprite2D.play("run")

	elif Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
		current_anim = "run"
		$AnimatedSprite2D.play("run")

	elif not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		current_anim = "idle"
		$AnimatedSprite2D.play("idle")

	if is_jumping:
		current_anim = "jump"
		$AnimatedSprite2D.play("jump")

func kill():
	self.position = checkpoint
	self.velocity = Vector2.ZERO
	is_jumping = false
	is_dashing = false
	is_climbing = false
	fast_falling = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_force_down"):
		self.position.y -= 1
	
	if event.is_action_pressed("ui_jump") and self.is_on_floor():
		is_jumping = true
		current_anim = "jump"
		$AnimatedSprite2D.play("jump")

	if event.is_action_pressed("ui_down") and not self.is_on_floor():
		fast_falling = true

	if event.is_action_released("ui_down"):
		fast_falling = false

	if event.is_action_pressed("ui_dash"):
		is_dashing = true
		print("Dashing - handle movement later")

	if event.is_action_pressed("ui_climb"):
		is_climbing = true
		self.velocity.y = -200
		print("Climbing - handle movement later")


func _on_animated_sprite_2d_animation_finished() -> void:
	if current_anim == "climbing":
		is_climbing = false
	if current_anim == "dashing":
		is_dashing = false

	current_anim = null


func _on_player_died() -> void:
	self.position = checkpoint


func _on_got_checkpoint(pos: Vector2) -> void:
	print('hi')
	print(pos)
	checkpoint = pos
