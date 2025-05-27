extends Node2D
@export var enemy_scenes: Array[PackedScene] = []
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen

var difficulty_increased := false
var enemy_speed_multiplier := 1.0
var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score

		if score >= 700 and not difficulty_increased:
			difficulty_increased = true
			enemy_speed_multiplier = 2.5
			_increase_difficulty()



var high_score


		


func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
		
	score = 0
	player = get_tree().get_first_node_in_group("player")
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)
	
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)


func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(100,1000), -100)
	e.killed.connect(_on_enemy_killed)

	if e is Enemy:
		e.speed *= enemy_speed_multiplier

	enemy_container.add_child(e)

	
func _on_enemy_killed(points):
	score += points
	if score > high_score:
		high_score = score
	
	
func _on_player_killed():
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(0.5).timeout
	gos.visible = true
	
func _increase_difficulty():
	for enemy in enemy_container.get_children():
		if enemy is Enemy:
			enemy.speed *= enemy_speed_multiplier
