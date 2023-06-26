extends Bug

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area = $Area2D
@onready var player = get_parent().get_parent().get_node("Player")

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
		if (area.get_overlapping_bodies().has(player)):
			if ((get_collision_direction(player) == Vector2.RIGHT && direction == 1)
			|| (get_collision_direction(player) == Vector2.LEFT && direction == -1)):
				player.damage(attack_damage)
			if (get_collision_direction(player).x == 0):
				player.push_strength.y = push_strength * get_collision_direction(player).y
			else:
				player.push_strength.x = push_strength * get_collision_direction(player).x
	
	last_velocity = velocity
	
	update_direction()
	move_and_slide()
	
