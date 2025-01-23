extends PowerUp

var shield_scene = preload("res://scenes/shield.tscn")
func apply_effect():
	var shield = shield_scene.instantiate()
	player.add_child(shield)
	shield.global_position = player.global_position
	
	restore_defaults.emit("shield")
