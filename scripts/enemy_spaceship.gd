extends Enemy

@onready var shoot_timer = $ShootTimer
@onready var muzzle = $Muzzle

var bullet_scene = preload("res://scenes/enemy_bullet.tscn")

signal bullet_shot

func _process(delta) -> void:
	position = position.move_toward(Vector2(position.x, 110), speed*delta)


func _on_shoot_timer_timeout() -> void:
	shoot()

func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)
