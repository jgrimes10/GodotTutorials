class_name Bullet
extends Area2D


@export var speed: float = 1000.0
@export var max_range: float = 1200.0
@export var bullet_damage_amount: float = 50.0

var current_travel_distance: float = 0.0


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Get the current direction that the projectile is pointing.
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	
	# Move the projectile.
	position += direction * speed * delta
	# Track the travelled distance.
	current_travel_distance += speed * delta
	
	# If the projectile has exceeded its max range.
	if current_travel_distance > max_range:
		# Destroy the projectile.
		queue_free()


# Called when the projectile enters another body that is on a layer
# that is being tracked.
func _on_body_entered(body: Node2D) -> void:
	# Delete the projectile.
	queue_free()
	
	# If the body the projectile hit can take damage, do that.
	if body.has_method("take_damage"):
		body.take_damage(0)
