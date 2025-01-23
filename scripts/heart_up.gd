extends PowerUp

func apply_effect():
	player.heart_up.emit()
