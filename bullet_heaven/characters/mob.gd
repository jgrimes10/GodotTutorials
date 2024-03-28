extends CharacterBody2D


const SMOKE_SCENE: PackedScene = preload("res://bullet_heaven/smoke_explosion/smoke_explosion.tscn")

@onready var player: CharacterBody2D = get_node("/root/BulletHeaven/Player")

@export var max_speed: float = 100.0
@export var max_health: float = 100.0
@export var damage_amount: float = 0.5

var current_health: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the current_health when the mob is instantiated.
	current_health = max_health
	
	# Start the slime's walking animation.
	%Slime.play_walk()


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Make sure the mob has a player to track.
	if not player:
		printerr("Mob cannot find player!")
		return
	
	# Get the direction pointing to the player.
	var direction_to_player: Vector2 = global_position.direction_to(player.global_position)
	
	# Move the mob toward the player.
	velocity = direction_to_player * max_speed
	
	# Apply the movement.
	move_and_slide()


## Method that damages the mob by the amount (float) passed in.
func take_damage(amount: float) -> void:
	# Subtract passed in amount from the mob's current health.
	current_health -= amount
	# Play the hurt animation.
	%Slime.play_hurt()
	
	# Check if the mob's health is depleted.
	if current_health <= 0:
		# Kill the mob.
		_die()


## Method to get the amount of damage this mob will do to the player.
func get_player_damage() -> float:
	return damage_amount


## Method that handles what happens when the mob dies.
func _die() -> void:
	# Delete the instance.
	queue_free()
	
	# Create a new instance of the smoke scene.
	var smoke: Node2D = SMOKE_SCENE.instantiate()
	# Set the smoke's position to the position of the mob.
	smoke.global_position = global_position
	# Add the smoke to the mob's parent so it isn't deleted
	# when the mob is.
	get_parent().add_child(smoke)
