extends PowerUp

func apply_effect():
	player.speed *= 2
	restore_defaults.emit("speed")
