extends Bug

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	can_capture = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	animated_sprite_2d.play("Walk")
	fall(delta)
	
	if (just_thrown):
		handle_throw()
	else:
		if (is_on_floor()):
			velocity = velocity.move_toward(Vector2.RIGHT * direction * speed, speed)
		if (is_on_wall() and is_on_floor()):
			direction *= -1
	
	last_velocity = velocity
	
	update_direction()
	move_and_slide()
	
