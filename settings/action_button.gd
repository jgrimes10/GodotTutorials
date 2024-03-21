extends Button


@export var action: String = "ui_up"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_key_input(false)
	_display_key()


func _unhandled_key_input(event: InputEvent) -> void:
	# Remap to the new event.
	remap_action_to(event)
	# Set key process to false.
	set_process_unhandled_key_input(false)
	# Release key.
	release_focus()


## This function is used to remap the controls for a given action.
func remap_action_to(event: InputEvent) -> void:
	# Erase the previous event.
	InputMap.action_erase_events(action)
	# Assign the new event.
	InputMap.action_add_event(action, event)
	
	# Update the controls.
	Persistence.update_control(action, event)
	
	# Update the text of the button to the new key.
	text = event.as_text()


## This method assigns the text value of this button to the key
## pressed in the InputMap event.
func _display_key() -> void:
	# Text here is the the built-in "text" property of the
	# button (not a variable defined in this script).
	text = InputMap.action_get_events(action)[0].as_text()


## This method fires whenever the ActionButton is pressed.
func _on_pressed() -> void:
	# Turn on key process.
	set_process_unhandled_key_input(true)
	# Change this button's text.
	text = "Press any key"
