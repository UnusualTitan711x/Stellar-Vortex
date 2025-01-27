extends Control

func _ready() -> void:
	AudioPlayer.play_music_level()

func _on_play_pressed() -> void:
	visible = false
	$"../SpaceshipSelectionScreen".visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
