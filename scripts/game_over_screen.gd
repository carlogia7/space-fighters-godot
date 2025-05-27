extends Control


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/Score.text = "PONTUAÇÃO: " + str(value)
	

func set_high_score(value):
	$Panel/HighScore.text = "MAIOR PONTUAÇÃO: " + str(value) 
