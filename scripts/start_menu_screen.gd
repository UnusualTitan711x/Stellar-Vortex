extends Control

func _on_play_pressed() -> void:
	visible = false
	$"../SpaceshipSelectionScreen".visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
