extends Area2D

@onready var bugs_folder = get_node("/root/Node2D/Bugs")
@onready var captured_bugs_label = $"../HUD/CapturedBugsLabel"
@onready var throw_delay = $ThrowDelay

var captured_bugs: Array[Bug] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and captured_bugs.size() > 0 and throw_delay.time_left == 0):
		throw_delay.start()
		var thrown_bug = captured_bugs[0].duplicate()
		bugs_folder.add_child(thrown_bug)
		var difference = get_global_mouse_position() - get_parent().global_position
		var angle = atan2(difference.y, difference.x)
		thrown_bug.global_position = global_position
		if (difference.x > 0):
			thrown_bug.direction = 1
		else:
			thrown_bug.direction = -1
		thrown_bug.update_direction()
		thrown_bug.velocity = difference.normalized() * 400
		thrown_bug.just_thrown = true
		captured_bugs.remove_at(0)
	
	captured_bugs_label.text = str(captured_bugs.size())

func _on_body_entered(body : Bug):
	if (body.can_capture):
		captured_bugs.append(body.duplicate())
		body.queue_free()
