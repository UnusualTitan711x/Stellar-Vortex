extends Area2D

func _ready() -> void:
	await get_tree().create_timer(.75).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
		queue_free()
