extends Node2D

var player = null
@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var bullet_container = $LaserContainerE
@onready var enemy_container = $EnemyContainer
@onready var s_point_container = $SpawnPointContainer
@onready var powerup_container = $PowerupContainer
@onready var spawn_timer = $EnemySpawnTimer
@onready var hud = $UILayer/HUD
@onready var game_over_screen = $UILayer/GameOverScreen
@onready var pause_menu = $UILayer/PauseMenu
@onready var parallax_bg = $ParallaxBackground
@onready var ss_timer = $SpaceshipSpawnTimer
@onready var boss_spawn_pos = $BossSpawnPosition

@onready var laser_sound = $SFX/LaserSound
@onready var laser_sound_2 = $SFX/LaserSound2
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound
@onready var powerup_sound = $SFX/PowerUpSound
@onready var heart_up_sound = $SFX/HeartUpSound
@onready var player_damage_sound = $SFX/PlayerDamageSound


# This takes away the hassle of going into the script somwehere and updating the display
# This does it automatically. Cool
var score := 0:
	set(value):
		score = value
		hud.score = score 

var lives := 3:
	set(value):
		lives = value
		hud.lives = lives

var high_score
var spawn_points
var scroll_speed = 100

var paused = false
var boss_spawned = false

@export var powerup_duration = 5
@export var boss_spawn_score = 1000

@export var meteor_scenes: Array[PackedScene] = []
@export var enemy_scenes: Array[PackedScene] = []
@export var powerup_scenes: Array[PackedScene] = []

var boss_scene = preload("res://scenes/mothership.tscn")

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
	
	spawn_points = s_point_container.get_children()
	
	var player_path = GlobalData.player_character_path
	player = load(player_path).instantiate()
	add_child(player)
	
	# This basically makes the player accessible everywhere
	# Another approach is by doing @onready var player = $Player 
	player = get_tree().get_first_node_in_group("player")
	assert(player != null) # Gives an error if the player is not found
	
	# Set the player to the spawn position
	player.global_position = player_spawn_pos.global_position
	
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)
	player.damaged.connect(_on_player_damaged)
	player.heart_up.connect(_on_heart_up)

func save_game():
	# Opens a file for writing, creates one if it doesn't exist
	# It wipes anything found there before and writes what you want in it
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

# Process works every frame. Similar to Update() in Unity
func _process(delta):
	if Input.is_action_just_pressed("pause") and !game_over_screen.visible:
		if paused == false:
			pause_game()
		else:
			pause_game()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if spawn_timer.wait_time > 0.6:
		spawn_timer.wait_time -= delta * 0.01
	elif spawn_timer.wait_time < 0.6:
		spawn_timer.wait_time = 0.6
	
	parallax_bg.scroll_offset.y += delta * scroll_speed
	
	if parallax_bg.scroll_offset.y >= 960:
		parallax_bg.scroll_offset.y = 0
	
	if (score > boss_spawn_score and not boss_spawned):
		spawn_boss()
		boss_spawned = true

func pause_game():
	get_tree().paused = true
	paused = true
	pause_menu.show()

func resume_game():
	get_tree().paused = false
	paused = false
	pause_menu.hide()

func _on_player_laser_shot(laser_scene, location):
	laser_sound.play()
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_heart_up():
	heart_up_sound.play()
	hud.powerup_text = "heart ++"
	lives += 1

func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = meteor_scenes.pick_random().instantiate()
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

func _on_player_damaged():
	player_damage_sound.play()
	lives = lives - 1
	if lives <= 0:
		player.die()


func _on_spaceship_spawn_timer_timeout() -> void:
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = spawn_points.pick_random().global_position
	enemy.killed.connect(_on_enemy_killed)
	enemy.hit.connect(_on_enemy_hit)
	enemy_container.add_child(enemy)
	enemy.bullet_shot.connect(_on_enemy_bullet_shot)

func _on_enemy_bullet_shot(bullet_scene, location):
	laser_sound_2.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	bullet_container.add_child(bullet)


func _on_power_up_timer_timeout() -> void:
	var powerup = powerup_scenes.pick_random().instantiate()
	powerup.global_position = Vector2(randf_range(30, 510), -20)
	powerup.restore_defaults.connect(_on_restore_default)
	powerup_container.add_child(powerup)

func _on_restore_default(attribute):
	powerup_sound.play()
	if attribute == "fire_rate":
		hud.powerup_text = "fire rate ++"
		await get_tree().create_timer(powerup_duration).timeout
		if player != null:
			player.fire_rate *= 2
	elif attribute == "speed":
		hud.powerup_text = "movement ++"
		await get_tree().create_timer(powerup_duration).timeout
		if player != null:
			player.speed = 300
	elif attribute == "shield":
		hud.powerup_text = "shield ++"
		await get_tree().create_timer(powerup_duration).timeout
		if player != null:
			var shield = player.get_node("Shield")
			if shield != null:
				shield.queue_free()
	elif attribute == "2x":
		if player != null:
			await get_tree().create_timer(powerup_duration).timeout
			player.laser_scene = preload("res://scenes/laser.tscn")

func spawn_boss():
	print("Boss spawned!")
	var boss = boss_scene.instantiate()
	boss_spawn_pos.add_child(boss)
	boss.global_position = boss_spawn_pos.global_position
	boss.boss_killed.connect(_on_boss_killed)
	
	for beamer in boss.beamer_scenes: 
		beamer.bullet_shot.connect(_on_enemy_bullet_shot)

func _on_boss_killed(points, boss):
	for beamer in boss.beamer_scenes:
		boss.beamer_container.remove_child(beamer)
		add_child(beamer)
		beamer.global_position.x += 270
		print("beamer saved")
	
	boss_spawned = false
	boss.queue_free()
	
