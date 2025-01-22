extends Enemy

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func _ready() -> void:
	var sprite = get_node("Sprite2D")
	sprite.rotation_degrees = randf_range(0, 360)
