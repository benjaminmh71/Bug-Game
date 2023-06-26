extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var health_label = $"HUD/HealthLabel"
@onready var invincibility_timer = $InvincibilityTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var push_strength = Vector2.ZERO

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Move
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (push_strength != Vector2.ZERO):
		velocity = push_strength
		push_strength = Vector2.ZERO
	
	move_and_slide()
	
	health_label.text = str(health)

func damage(damage_amount):
	if (invincibility_timer.time_left > 0): return
	health -= damage_amount
	invincibility_timer.start()
	if (health <= 0):
		get_tree().reload_current_scene()
