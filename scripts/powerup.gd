extends Area2D
class_name PowerUp

var player

signal restore_defaults

@export var speed = 150

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# Move down
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

# When touching Player, apply effext
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
		apply_effect()

func apply_effect():
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
