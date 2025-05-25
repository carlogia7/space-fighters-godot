extends Node

var moved = false
@export var controller: Node

func _process(_delta):
	if moved:
		return
		
	if Input.is_action_just_pressed("shoot"):
		moved = true
		print("tutorial de shoot feito!")
		controller.tutorial_is_done()
