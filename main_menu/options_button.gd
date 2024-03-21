extends Button


@onready var settings = %SettingsMargin

## Called when the Options button is pressed on the Main Menu.
func _on_pressed() -> void:
	# Show the settings.
	settings.show()
	# Hide the parent.
	get_parent().hide()
