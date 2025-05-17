extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Tutorial.tscn")
