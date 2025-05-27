extends Control
@onready var score = $Score:
	set(value):
		score.text = "PONTUAÇÃO: " + str(value)
