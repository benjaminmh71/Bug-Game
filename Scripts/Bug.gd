extends CharacterBody2D
class_name Bug

@export var health = 1
@export var speed = 300.0
@export var jump_velocity = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_capture = false

func jump():
	if is_on_floor():
		velocity.y = jump_velocity

func fall(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
