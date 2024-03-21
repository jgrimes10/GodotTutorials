extends Node2D


@onready var tile_map: TileMap = $"../TileMap"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var move_speed: float = 1.0

var is_moving: bool = false


# Called every physics tick. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# If player is not moving, no need to do anything.
	if is_moving == false:
		return
	
	# Sprite & player object in same place == finished moving.
	if global_position == sprite_2d.global_position:
		is_moving = false
		return
	
	# We are moving & not at the destination yet.
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, move_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving == false:
		_listen_for_movement_input()


## Handles up, down, left, and right input (key mappings can be
## changed in options).
func _listen_for_movement_input() -> void:
	if Input.is_action_pressed("ui_up"):
		_move(Vector2.UP)
	elif Input.is_action_pressed("ui_down"):
		_move(Vector2.DOWN)
	elif Input.is_action_pressed("ui_left"):
		_move(Vector2.LEFT)
	elif Input.is_action_pressed("ui_right"):
		_move(Vector2.RIGHT)


## Moves the player based on the Vector2 direction that is passed in.
func _move(direction: Vector2) -> void:
	# Get the current tile Vector2i.
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i.
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	# Get custom data layer for target tile.
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	# If the tile we are trying to move to is not walkable.
	if tile_data.get_custom_data("walkable") == false:
		return
	
	# Make sure we are not going to collide with anything.
	# Set the raycast to look to the target tile.
	ray_cast_2d.target_position = direction * 16
	# Force raycast to update instead of waiting for next frame.
	ray_cast_2d.force_raycast_update()
	
	# If the player is going to collide with something, bail.
	if ray_cast_2d.is_colliding():
		return
	
	is_moving = true
	
	# Move the player object to the target tile.
	global_position = tile_map.map_to_local(target_tile)
	# Move the sprite back to the previous tile so we can animate it.
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
