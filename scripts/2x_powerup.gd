extends PowerUp

func apply_effect():
	player.laser_scene = preload("res://scenes/laser_x2.tscn")
	restore_defaults.emit("2x")
