extends CharacterBody2D

const MAX_PLAYER_SPEED: float = 600.0
const ACCELERATION: float = 1500
const FRICTION: float = 1000

var input: Vector2 = Vector2.ZERO


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_player_movement(delta)
	

func _get_input() -> Vector2:
	# Get the input direction.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return direction.normalized()


func _player_movement(delta: float) -> void:
	input = _get_input()
	
	if (velocity != Vector2.ZERO):
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	# If the player isn't inputting any movement.
	if input == Vector2.ZERO:
		# But the character is still moving, slow down with friction.
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			# Otherwise, we're completely stopped.
			velocity = Vector2.ZERO
	# The player is inputting movement.
	else:
		# Move the player.
		velocity += (input * ACCELERATION * delta)
		# Cap the player's speed to the max.
		velocity = velocity.limit_length(MAX_PLAYER_SPEED)
	
	# Apply the movement to the player.
	move_and_slide()
