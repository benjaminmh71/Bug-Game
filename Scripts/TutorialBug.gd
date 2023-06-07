extends Bug

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var Raycast = $RayCast2D

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	can_capture = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	animated_sprite_2d.play("Walk")
	fall(delta)
	
	velocity.x = direction * speed
	if (Raycast.is_colliding() and not (Raycast.get_collider() is CharacterBody2D)):
		direction *= -1
		scale.x *= -1
	move_and_slide()
