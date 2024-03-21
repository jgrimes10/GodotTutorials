extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the button state of the video settings based on values loaded in from the config.
	# Fullscreen button state.
	var screen_type: DisplayServer.WindowMode = Persistence.config.get_value("Video", "fullscreen")
	if screen_type == DisplayServer.WINDOW_MODE_FULLSCREEN:
		%FullScreen.button_pressed = true
	
	# Borderless button state.
	var borderless_type: bool = Persistence.config.get_value("Video", "borderless")
	if borderless_type == true:
		%Borderless.button_pressed = true
	
	# Vsync selector state.
	var vsync_index: DisplayServer.VSyncMode = Persistence.config.get_value("Video", "vsync")
	%Vsync.selected = vsync_index


## This method fires whenever the checkbox for FullScreen is toggled on or off.
## It controls whether the game is in fullscreen mode or not.
func _on_full_screen_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Persistence.update_video_setting("fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Persistence.update_video_setting("fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)


## This method fires whenever the checkbox for Borderless is toggled on or off.
## It controls whether the game is in borderless mode or not.
func _on_borderless_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	Persistence.update_video_setting("borderless", toggled_on)


## This method fires whenever an item is selected in the Vsync selection box.
## It controls if vsync is enabled or not and what mode.
func _on_vsync_item_selected(index: int) -> void:
	DisplayServer.window_set_vsync_mode(index)
	Persistence.update_video_setting("vsync", index)
