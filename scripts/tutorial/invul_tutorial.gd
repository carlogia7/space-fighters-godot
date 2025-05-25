extends Node

var moved = false
@export var controller: Node

func _process(_delta):
	if moved:
		return
		
	if Input.is_action_pressed("invul"):
		moved = true
		print("tutorial de invulnerabilidade feito!")
		controller.tutorial_is_done()
