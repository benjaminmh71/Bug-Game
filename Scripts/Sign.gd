extends Node2D

@export var text = ""
@onready var player = get_node("/root/Node2D/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((global_position -player.global_position).length() < 100):
		$Label.text = text
	else:
		$Label.text = ""
