extends Button


## Called when the Quit button is pressed on the Main Menu.
func _on_pressed() -> void:
	# Close out the game completely.
	get_tree().quit()
