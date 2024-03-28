extends CharacterBody2D


signal player_died


const BASE_MAX_SPEED: float = 400.0
const BASE_MAX_HEALTH: float = 100.0
const ACCELERATION: float = 1200
const FRICTION: float = 1000

var input: Vector2 = Vector2.ZERO
var current_health: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the current health when the player is instantiated.
	current_health = BASE_MAX_HEALTH


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_player_movement(delta)
	_handle_collisions()


## Method to handle doing damage to the player
func _take_damage(amount: float) -> void:
	# Subtract from the current health.
	current_health -= amount
	# Update the health bar
	_update_health_bar()
	
	# Check if the player's health is depleted.
	if current_health <= 0:
		_die()


## Method to handle the player dying.
func _die() -> void:
	player_died.emit()


## Method to trigger an update to the health bar.
func _update_health_bar() -> void:
	# Current health percentage
	var health_percentage: float = (current_health / BASE_MAX_HEALTH) * 100
	
	%HealthBar.value = health_percentage


## Method to handle collisions checks of bodies touching the player.
func _handle_collisions() -> void:
	# Get all of the overlapping bodies with the player.
	var overlapping_mobs: Array[Node2D] = %HurtBox.get_overlapping_bodies()
	# If anything is touching the player.
	if overlapping_mobs.size() > 0:
		# Variable to track total damage from everything touching the player.
		var total_damage: float = 0.0
		# Loop through all of the mobs currently touching the player.
		for mob in overlapping_mobs:
			# Check and make sure it actually is a mob.
			if mob.has_method("get_player_damage"):
				# Get the amount of damage that this mob does
				total_damage += mob.get_player_damage()
		
		# Do the damage to the player
		_take_damage(total_damage)


## Method to handle getting the player's input.
func _get_input() -> Vector2:
	# Get the input direction.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	return direction.normalized()


## Method to handle moving the player.
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
		velocity = velocity.limit_length(BASE_MAX_SPEED)
	
	# Apply the movement to the player.
	move_and_slide()
