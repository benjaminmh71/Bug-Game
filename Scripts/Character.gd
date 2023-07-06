extends CharacterBody2D

@export var dialogue = ""

var reader = DialogueReader.new()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_section: DialogueReader.Section

@onready var file = FileAccess.open(dialogue, FileAccess.READ)
@onready var dialogue_box = $DialogueBox
@onready var label = $DialogueBox/Panel/VBoxContainer/Label
@onready var option_1 = $DialogueBox/Panel/VBoxContainer/Option1
@onready var option_2 = $DialogueBox/Panel/VBoxContainer/Option2
@onready var option_3 = $DialogueBox/Panel/VBoxContainer/Option3
@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var sections = reader.generate_sections(file)
	current_section = reader.get_first_section(file)
	option_1.pressed.connect(button_1_pressed)
	option_2.pressed.connect(button_2_pressed)
	option_3.pressed.connect(button_3_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if (Input.is_action_just_pressed("interact") and (global_position - player.global_position).length() < 100):
		if (dialogue_box.visible == false):
			current_section = reader.get_first_section(file)
		dialogue_box.show()
	
	label.text = current_section.text
	if (current_section.options.size() > 0):
		option_1.show()
		option_1.text = current_section.options[0]
	else:
		option_1.hide()
		dialogue_box.hide()
	
	if (current_section.options.size() > 1):
		option_2.show()
		option_2.text = current_section.options[1]
	else:
		option_2.hide()
	
	if (current_section.options.size() > 2):
		option_3.show()
		option_3.text = current_section.options[2]
	else:
		option_3.hide()

func button_1_pressed():
	current_section = reader.get_section(current_section.links[0])

func button_2_pressed():
	current_section = reader.get_section(current_section.links[1])

func button_3_pressed():
	current_section = reader.get_section(current_section.links[2])
