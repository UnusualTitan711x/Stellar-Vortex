extends Node2D

var player = null
@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var spawn_timer = $EnemySpawnTimer
@onready var hud = $UILayer/HUD
@onready var game_over_screen = $UILayer/GameOverScreen
@onready var parallax_bg = $ParallaxBackground

@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound

var score := 0:
	set(value):
		score = value
		hud.score = score 
var high_score

var scroll_speed = 100
# This takes away the hassle of going into the script somwehere and updating the display
# This does it automatically. Cool

@export var enemy_scenes: Array[PackedScene] = []

# _ready() is called at the start of the game.
func _ready() -> void:
	# Reads what is in the file into the high_score variable
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	
	#checking if file exists and saves the game if it doesn't
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	
	# Whenever I set the score, it always take the formatting I made when creating score. Nice!
	score = 0
	
	# This basically makes the player accessible everywhere
	# Another approach is by doing @onready var player = $Player 
	player = get_tree().get_first_node_in_group("player")
	assert(player != null) # Gives an error if the player is not found
	
	# Set the player to the spawn position
	player.global_position = player_spawn_pos.global_position
	
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func save_game():
	# Opens a file for writing, creates one if it doesn't exist
	# It wipes anything found there before and writes what you want in it
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

# Process works every frame. Similar to Update() in Unity
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if spawn_timer.wait_time > 0.4:
		spawn_timer.wait_time -= delta * 0.02
	elif spawn_timer.wait_time < 0.4:
		spawn_timer.wait_time = 0.4
	
	parallax_bg.scroll_offset.y += delta * scroll_speed
	
	if parallax_bg.scroll_offset.y >= 960:
		parallax_bg.scroll_offset.y = 0

func _on_player_laser_shot(laser_scene, location):
	laser_sound.play()
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(randf_range(30, 510), -20)
	enemy.killed.connect(_on_enemy_killed)
	enemy.hit.connect(_on_enemy_hit)
	enemy_container.add_child(enemy)

func _on_enemy_hit():
	hit_sound.play()

func _on_enemy_killed(points):
	hit_sound.play()
	score += points
	if score > high_score:
		high_score = score

func _on_player_killed():
	explode_sound.play()
	game_over_screen.set_score(score)
	game_over_screen.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1).timeout
	game_over_screen.visible = true
