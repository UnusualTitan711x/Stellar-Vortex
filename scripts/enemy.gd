class_name Enemy extends Area2D

@export var speed = 150
@export var hp = 3
@export var points = 10

# If you want to emit a signal, you could do emit_signal("signal_name")
# Otherwise, you can go the way of creating a signal then emitting it somwhere else
signal killed
signal hit

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func die():
	killed.emit(points)
	queue_free()
	

func take_damage(amount):
	hp -= amount
	if hp <=0:
		die()
	else:
		hit.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
		queue_free()
