extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 2000.0
const FRICTION = 1500.0
const JUMP_VELOCITY = -400.0
const CLIMBING_SPEED = 3
const VINE_LENGTH = 256
const MAX_HEALTH = 100

@onready var health_label = $"HUD/HealthLabel"
@onready var invincibility_timer = $InvincibilityTimer
@onready var coyote_timer = $CoyoteTimer
@onready var wall_coyote_timer = $WallCoyoteTimer
@onready var spawn_point = global_position

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var push_strength = Vector2.ZERO
var is_climbing = false
var climbing_vine : Vine
var climbing_distance = 0

func _physics_process(delta):
	if (is_climbing):
		handle_climbing()
		handle_jump()
	else:
		apply_gravity(delta)
		handle_jump()
		handle_movement(delta)
		handle_push()
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	
	move_and_slide()
	
	if (was_on_floor and not is_on_floor() and velocity.y >= 0):
		coyote_timer.start()
	if (was_on_wall and not is_on_wall()):
		wall_coyote_timer.start()
	
	if (health <= 0):
		global_position = spawn_point
		velocity = Vector2.ZERO
		health = MAX_HEALTH
	
	health_label.text = str(health)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0 or is_climbing):
		velocity.y = JUMP_VELOCITY
		is_climbing = false

func handle_wall_jump():
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = JUMP_VELOCITY
		velocity.x = SPEED * get_wall_normal().x

func handle_movement(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_push():
	if (push_strength != Vector2.ZERO):
		velocity = push_strength
		push_strength = Vector2.ZERO

func handle_climbing():
	global_position = climbing_vine.global_position + Vector2.from_angle(climbing_vine.global_rotation + PI/2) * climbing_distance
	velocity = Vector2.ZERO
	if (Input.is_action_pressed("up") and climbing_distance > 0):
		climbing_distance -= CLIMBING_SPEED
	if (Input.is_action_pressed("down") and climbing_distance < VINE_LENGTH):
		climbing_distance += CLIMBING_SPEED

func damage(damage_amount):
	if (invincibility_timer.time_left > 0): return
	health -= damage_amount
	invincibility_timer.start()
	if (health <= 0):
		get_tree().reload_current_scene()
