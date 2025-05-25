extends Node

var moved = false
@export var controller: Node

func _process(_delta):
	if moved:
		return
		
	if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left") \
		or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		moved = true
		print("tutorial de movimento feito!")
		controller.tutorial_is_done()
