extends Area2D

@export var speed = 600
@export var damage = 1

func _physics_process(delta: float) -> void:
	global_position.y += -speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.take_damage(damage)
		queue_free()
