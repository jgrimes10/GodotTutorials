extends Button


@onready var main_menu = %MainMenu
@onready var settings = %SettingsMargin


## Called when the Back button is pressed on the Options screen.
func _on_pressed() -> void:
	# Show the main menu.
	main_menu.show()
	# Hide the settings.
	settings.hide()
