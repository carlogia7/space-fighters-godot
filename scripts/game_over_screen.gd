extends Control


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

func set_score(value):
	$Panel/Score.text = "PONTUAÇÃO: " + str(value)
	

func set_high_score(value):
	$Panel/HighScore.text = "MAIOR PONTUAÇÃO: " + str(value) 
