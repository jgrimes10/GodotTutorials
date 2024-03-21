extends Node


const PATH: String = "user://settings.cfg"
const CONTROLS_SECTION: String = "Controls"
const VIDEO_SECTION: String = "Video"
const AUDIO_SECTION: String = "Audio"

var config: ConfigFile = ConfigFile.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set all the default actions and events in "Controls" section in config file.
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			config.set_value(CONTROLS_SECTION, action, InputMap.action_get_events(action)[0])
	
	# Set default values for video settings (will be set only for the first run).
	config.set_value(VIDEO_SECTION, "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value(VIDEO_SECTION, "borderless", true)
	config.set_value(VIDEO_SECTION, "vsync", DisplayServer.VSYNC_ENABLED)
	
	# Set default values for audio settings (will be set only for the first run).
	for i in range(3):
		config.set_value(AUDIO_SECTION, str(i), 0.0)
	
	_load_data()


# -------------------------- 
#           PUBLIC
# --------------------------

## Updates an event and saves the new value in the controls
## section of the config file.
func update_control(action: String, event: InputEvent) -> void:
	config.set_value(CONTROLS_SECTION, action, event)
	_save_data()


## Updates a setting in the video section of the config file.
func update_video_setting(setting: String, value: Variant) -> void:
	config.set_value(VIDEO_SECTION, setting, value)
	_save_data()


## Updates the volume setting for the specified audio bus in the audio
## section of the config file.
func update_audio_setting(bus_id: int, value: float) -> void:
	config.set_value(AUDIO_SECTION, str(bus_id), value)
	_save_data()


# --------------------------- 
#           PRIVATE
# ---------------------------

## Writes the config data in a file at location PATH.
func _save_data() -> void:
	config.save(PATH)

## This method is used to load the configuration data from a file at PATH.
func _load_data() -> void:
	# Try to load the config, if it doesn't exist - save the default
	# values and return.
	if config.load(PATH) != OK:
		_save_data()
		return
	
	# Load control settings if file exists.
	_load_control_settings()
	_load_video_settings()


## Gets the Control configs and changes the corresponding settings.
func _load_control_settings() -> void:
	# Get all keys from section "Controls" in the config file.
	var keys: PackedStringArray = config.get_section_keys(CONTROLS_SECTION)
	
	# Get every action from the config file.
	for action in InputMap.get_actions():
		if keys.has(action):
			var value: InputEvent = config.get_value(CONTROLS_SECTION, action)
			
			# Erase the default event.
			InputMap.action_erase_events(action)
			# Override with new loaded value.
			InputMap.action_add_event(action, value)


## Gets the Video configs and changes the corresponding settings.
func _load_video_settings() -> void:
	# Get the fullscreen setting from config and set it.
	var screen_type: DisplayServer.WindowMode = config.get_value(VIDEO_SECTION, "fullscreen")
	DisplayServer.window_set_mode(screen_type)
	
	# Get the borderless setting from config and set it.
	var borderless: bool = config.get_value(VIDEO_SECTION, "borderless")
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderless)
	
	# Get the vsync setting from config and set it.
	var vsync_index: DisplayServer.VSyncMode = config.get_value(VIDEO_SECTION, "vsync")
	DisplayServer.window_set_vsync_mode(vsync_index)
