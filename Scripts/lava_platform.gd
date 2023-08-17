extends StaticBody2D

const VELOCITY = 1.5
const VARIANCE = 20

@onready var origin = global_position

var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y = origin.y + sin(timer) * VARIANCE
	
	timer += VELOCITY * delta
