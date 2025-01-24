extends Control

var start_scene = load("res://scenes/start_menu.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(start_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
