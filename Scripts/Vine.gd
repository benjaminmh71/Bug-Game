extends Area2D
class_name Vine

const ANGULAR_VELOCITY = 1

@onready var player = %Player

var angle = 0
var angular_velocity = ANGULAR_VELOCITY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = sin(angle)/2
	
	angle += angular_velocity * delta
	
	if (angle >= TAU):
		angle = 0
	
	if (get_overlapping_bodies().size() > 0 and (Input.is_action_pressed("up") or Input.is_action_pressed("down")) and not player.is_climbing):
		player.is_climbing = true
		player.climbing_vine = self
		player.climbing_distance = global_position.distance_to(player.global_position)
