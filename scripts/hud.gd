extends Control

@onready var powerup_text = $PowerUpText:
	set(value):
		powerup_text.visible = true
		powerup_text.text = "[wave amp=30 freq=10] " + value + "[/wave]"
		await get_tree().create_timer(2).timeout
		powerup_text.visible = false

@onready var score = $Score:
	# Here is how to make object specific functions. Make things easier down the road. Nice
	set(value):
		score.text = "Score: " + str(value)

@onready var lives = $Lives:
	set(value):
		lives.text = str(value)
