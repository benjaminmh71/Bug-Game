extends Area2D

@onready var bugs = get_node("/root/Node2D/Bugs")

# Called when the node enters the scene tree for the first time.
func _ready():
	for bug in bugs.get_children():
		body_entered.connect(bug.on_vacuum)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		show()
		monitorable = true
		monitoring = true
		var difference = get_global_mouse_position() - get_parent().global_position
		var angle = atan2(difference.y, difference.x)
		rotation = angle
	else:
		hide()
		monitorable = false
		monitoring = false
