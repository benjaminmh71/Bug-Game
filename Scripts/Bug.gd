extends CharacterBody2D
class_name Bug

@export var health = 1.0
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var attack_damage = 0.0
@export var throw_damage = 0.0
@export var self_throw_damage = 0.0
@export var push_strength = 300.0

const push_margin = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_capture = false
var direction = 1
var just_thrown = false
var last_velocity = Vector2(0,0)

func damage(damage_amount):
	health -= damage_amount
	if (health <= 0):
		die()

func die():
	queue_free()

func jump():
	if is_on_floor():
		velocity.y = jump_velocity

func fall(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func update_direction():
	if (direction == 1):
		scale.y = 1
		rotation = 0
	if (direction == -1):
		scale.y = -1
		rotation = PI

func get_collision_direction(object: Node2D):
	var rect : Rect2 = $CollisionShape2D.shape.get_rect()
	if (object.global_position.x > global_position.x + rect.size.x/2):
		return Vector2.RIGHT
	elif (object.global_position.x < global_position.x - rect.size.x/2):
		return Vector2.LEFT
	elif (object.global_position.y < global_position.y - rect.size.y/2 + push_margin):
		return Vector2.UP
	elif (object.global_position.y > global_position.y + rect.size.y/2 - push_margin):
		return Vector2.DOWN
	elif (object.global_position.x > global_position.x):
		return Vector2.RIGHT
	elif (object.global_position.x < global_position.x):
		return Vector2.LEFT

func is_bug(value):
	return value is Bug and value != self

func handle_throw():
	var area: Area2D = get_node_or_null("Area2D")
	if (!area): return
	if (is_on_floor()):
		just_thrown = false
		velocity.y = -last_velocity.y
		damage(self_throw_damage)
	elif (is_on_wall()):
		just_thrown = false
		velocity.x = -last_velocity.x
		damage(self_throw_damage)
	elif (area.get_overlapping_bodies().any(is_bug)):
		var hit_bug: Bug = area.get_overlapping_bodies().filter(is_bug)[0]
		var collision_direction = get_collision_direction(hit_bug)
		just_thrown = false
		hit_bug.damage(throw_damage)
		damage(self_throw_damage)
		if (collision_direction == Vector2.UP or collision_direction == Vector2.DOWN):
			velocity.y *= -1
		else:
			velocity.x *= -1
			velocity.y -= speed
