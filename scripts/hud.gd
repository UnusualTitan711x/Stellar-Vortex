extends Control

@onready var score = $Score:
	# Here is how to make object specific functions. Make things easier down the road. Nice
	set(value):
		score.text = "Score: " + str(value)
