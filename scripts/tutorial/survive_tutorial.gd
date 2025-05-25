extends Node

@export var controller: Node

func _ready():
	
	print("início do survive")
	await get_tree().create_timer(30.0).timeout
	print("final do survive")
	controller.tutorial_is_done()
