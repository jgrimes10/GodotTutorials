extends Node2D


const MAIN_MENU = preload("res://main_menu/main_menu.tscn")


var _is_paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Go ahead and load up the main menu first.
	add_child(MAIN_MENU.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_listen_for_input()


## Listens for input from the player.
func _listen_for_input() -> void:
	if Input.is_action_just_pressed("pause"):
		_pause_menu()

## Pauses the game.
func _pause_menu() -> void:
	_is_paused = !_is_paused
	if not _is_paused:
		%PauseMenu.hide()
		Engine.time_scale = 1
	else:
		%PauseMenu.show()
		Engine.time_scale = 0
