extends Bug

@onready var Raycast = $RayCast2D

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	can_capture = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fall(delta)
	
	velocity.x = direction * speed
	if (Raycast.is_colliding() and not (Raycast.get_collider() is CharacterBody2D)):
		direction = direction * -1
		Raycast.target_position.x = Raycast.target_position.x * -1
	move_and_slide()
