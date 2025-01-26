extends Enemy

@onready var shoot_timer = $ShootTimer
@onready var muzzle = $Muzzle

@export var independent = false

var bullet_scene = preload("res://scenes/laser_beam.tscn")

signal bullet_shot

func _process(delta) -> void:
	if independent:
		position = position.move_toward(Vector2(position.x, 140), speed*delta)

func _on_shoot_timer_timeout() -> void:
	shoot()

func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)
