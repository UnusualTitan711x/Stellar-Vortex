class_name Player extends CharacterBody2D

@export var speed = 300
@export var fire_rate := 0.25

@onready var muzzle = $Muzzle
@onready var sprite = $Sprite2D

signal killed
signal damaged
signal heart_up

# In a signal like laser_shot(a, b), a and b are like information you want passed with the seignal
signal laser_shot(laser_scene, location)

var laser_scene = preload("res://scenes/laser.tscn")
var laserx2_scene = preload("res://scenes/laser_x2.tscn")

var shoot_cooldown := false

func _ready() -> void:
	sprite.texture = GlobalData.player_texture

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot()
			await get_tree().create_timer(fire_rate).timeout
			shoot_cooldown = false

# _physics_process is used when dealing with physics calculations in Godot
func _physics_process(delta: float) -> void:
	# Getting the player direction
	# Input.get_axis(a, b) sets the return value to -1 when a is pressed and 1 when b is pressed
	# "up" in the y-axis is -1 in Godot
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	# Sets the velocity to the direction times the speed
	velocity = direction * speed
	
	# This actually uses the velocity to make the player move.
	# The player doesn't just move by changing the velocity
	move_and_slide()
	
	global_position  = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)

func take_damage():
	damaged.emit()

func die():
	killed.emit()
	queue_free()
