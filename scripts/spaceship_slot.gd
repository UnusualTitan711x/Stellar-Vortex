extends Panel

@export var character_path: String
@export var spaceship_texture: CompressedTexture2D

func _ready() -> void:
	$Texture.texture = spaceship_texture
	

func set_selected(is_selected):
	var stylebox = get_theme_stylebox("panel").duplicate()
	
	if is_selected:
		stylebox.border_color = Color(1, 1, 1)
	else:
		stylebox.border_color = Color(0, 0, 0)
	
	add_theme_stylebox_override("panel", stylebox)
