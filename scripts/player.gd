extends CharacterBody2D

@export var speed = 300

# In a signal like laser_shot(a, b), a and b are like information you want passed with the seignal
signal laser_shot(laser_scene, location)

var laser_scene = preload("res://scenes/laser.tscn")

@onready var muzzle = $Muzzle

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

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

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)
