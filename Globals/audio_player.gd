extends AudioStreamPlayer

const level_music = preload("res://assets/8-bit-music-on-245249.mp3")

func play_music(music: AudioStream, volume = -8.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_level():
	play_music(level_music)
