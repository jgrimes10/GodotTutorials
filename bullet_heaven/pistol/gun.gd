extends Area2D


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Get all 2D nodes that are overlapping the area.
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies()
	
	# If there are enemies in shooting range.
	if enemies_in_range.size() > 0:
		# Aim at the enemy first enemy.
		var target_enemy: Node2D = enemies_in_range.front()
		look_at(target_enemy.global_position)
	else:
		rotation = 0
	
	var direction_from_center = get_parent().global_position - global_position
	var dot_product = Vector2.RIGHT.dot(direction_from_center)
	if rotation_degrees:
		%Pistol.flip_v = true
	else:
		%Pistol.flip_v = false

## Handles shooting a projectile from the gun.
func shoot() -> void:
	# Get the projectile scene.
	const PROJECTILE: PackedScene = preload("res://bullet_heaven/pistol/bullet.tscn")
	# Create a new projectile based on the scene.
	var new_projectile: Bullet = PROJECTILE.instantiate()
	
	# Set the projectile's position to the BulletSpawnPoint position
	# of the gun.
	new_projectile.global_position = %BulletSpawnPoint.global_position
	# Set the projectil's rotation to be the same as the
	# PivotPoint of the gun.
	new_projectile.global_rotation = %BulletSpawnPoint.global_rotation
	# Add the bullet as a child of the spawn point.
	%BulletSpawnPoint.add_child(new_projectile)


# Fires when the timer runs out.
func _on_timer_timeout() -> void:
	shoot()
