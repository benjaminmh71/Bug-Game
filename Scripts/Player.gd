extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 2000.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -400.0

@onready var health_label = $"HUD/HealthLabel"
@onready var invincibility_timer = $InvincibilityTimer
@onready var coyote_timer = $CoyoteTimer
@onready var wall_coyote_timer = $WallCoyoteTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var push_strength = Vector2.ZERO

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0):
		velocity.y = JUMP_VELOCITY
	
	# Handle Wall Jump
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = JUMP_VELOCITY
		velocity.x = SPEED * get_wall_normal().x
	
	# Move
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	if (push_strength != Vector2.ZERO):
		velocity = push_strength
		push_strength = Vector2.ZERO
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	
	move_and_slide()
	
	if (was_on_floor and not is_on_floor() and velocity.y >= 0):
		coyote_timer.start()
	if (was_on_wall and not is_on_wall()):
		wall_coyote_timer.start()
	
	health_label.text = str(health)

func damage(damage_amount):
	if (invincibility_timer.time_left > 0): return
	health -= damage_amount
	invincibility_timer.start()
	if (health <= 0):
		get_tree().reload_current_scene()
