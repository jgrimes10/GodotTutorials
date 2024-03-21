extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the slider state of the audio settings based on values loaded in from the config.
	# Master slider state.
	%Master.value = Persistence.config.get_value("Audio", '0')
	AudioServer.set_bus_volume_db(0, linear_to_db(%Master.value))
	
	# Music slider state.
	%Music.value = Persistence.config.get_value("Audio", '1')
	AudioServer.set_bus_volume_db(1, linear_to_db(%Music.value))
	
	# Sound effects slider state.
	%SFX.value = Persistence.config.get_value("Audio", '2')
	AudioServer.set_bus_volume_db(2, linear_to_db(%SFX.value))


## This method fires whenever the slider for Master changes.
## It controls the master volume for the game.
func _on_master_value_changed(value: float) -> void:
	_set_volume(0, value)


## This method fires whenever the slider for Music changes.
## It controls the music volume for the game.
func _on_music_value_changed(value: float) -> void:
	_set_volume(1, value)


## This method fires whenever the slider for SFX changes.
## It controls the sound effects volume for the game.
func _on_sfx_value_changed(value: float) -> void:
	_set_volume(2, value)


## This method is a helper function to adjust the volume of the
## passed in bus to the passed in value.
func _set_volume(idx: int, value: float) -> void:
	AudioServer.set_bus_volume_db(idx, linear_to_db(value))
	Persistence.update_audio_setting(idx, value)
