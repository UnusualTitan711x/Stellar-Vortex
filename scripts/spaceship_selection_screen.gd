extends Control

@onready var character_selection_box_1 = $VBoxContainer/SpaceshipType/HBoxContainer
@onready var character_selection_box_2 = $VBoxContainer/SpaceshipType2/HBoxContainer
@onready var character_selection_box_3 = $VBoxContainer/SpaceshipType3/HBoxContainer

var character_slots = []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == 1 && event.is_pressed():
		var char_node = get_char_node()
		
		if char_node:
			set_char_selected(char_node)

func get_char_node():
	var mouse_pos = get_viewport().get_mouse_position()
	
	character_slots += character_selection_box_1.get_children()
	character_slots += character_selection_box_2.get_children()
	character_slots += character_selection_box_3.get_children()
	
	for node in character_slots:
		if node.get_global_rect().has_point(mouse_pos):
			return node

func set_char_selected(char_node):
	print(char_node, " selected")
	GlobalData.player_character_path = char_node.character_path
	GlobalData.player_texture = char_node.spaceship_texture
	
	for node in character_slots:
		var is_selected = char_node == node
		node.set_selected(is_selected)


func _on_play_pressed() -> void:
	if not GlobalData.player_character_path:
		return
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back_pressed() -> void:
	visible = false
	$"../StartMenuScreen".visible = true
