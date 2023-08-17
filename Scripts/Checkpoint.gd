extends Area2D

@onready var player = %Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show()
	if get_overlapping_bodies().has(player):
		hide()
		player.spawn_point = global_position
