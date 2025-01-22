extends Node2D

var player = null
@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD

@export var score := 0:
	set(value):
		score = value
		hud.score = score 
# This takes away the hassle of going into the script somwehere and updating the display
# This does it automatically

@export var enemy_scenes: Array[PackedScene] = []

# _ready() is called at the start of the game.
func _ready() -> void:
	# Whenever I set the score, it always take the formatting I made when creating score. Nice!
	hud.score = 0
	
	# This basically makes the player accessible everywhere
	# Another approach is by doing @onready var player = $Player 
	player = get_tree().get_first_node_in_group("player")
	assert(player != null) # Gives an error if the player is not found
	
	# Set the player to the spawn position
	player.global_position = player_spawn_pos.global_position
	
	player.laser_shot.connect(_on_player_laser_shot)

# Process works every frame. Similar to Update() in Unity
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(30, 510), -20)
	enemy.killed.connect(_on_enemy_killed)
	enemy_container.add_child(enemy)

func _on_enemy_killed(points):
	score += points
	print(score)
