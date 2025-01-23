extends PowerUp

func apply_effect():
	player.fire_rate = 0.1
	restore_defaults.emit("fire_rate")
