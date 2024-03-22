extends CharacterBody2D

@onready var happy_boo: Node2D = $HappyBoo

@export var player_speed: float = 600.0


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Get the input direction.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Set the velocity.
	velocity = direction * player_speed
	
	# Move the player.
	move_and_slide()
	
	if (velocity != Vector2.ZERO):
		happy_boo.play_walk_animation()
	else:
		happy_boo.play_idle_animation() 
