extends Node2D

@onready var laser_container = $LaserContainer
@onready var labels = {
	"mov": $UI/MovLabel,
	"shoot": $UI/ShootLabel,
	"invul": $UI/InvulLabel,
	"survive": $UI/Survive,
	"victory": $UI/Victory
}
@onready var icons = {
	"WASD": $UI/WASD,
	"Mouse": $UI/Mouse
}
var player = null
var current_step = 0
var current_script = null
var step_done = false
var steps = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.laser_shot.connect(_on_player_laser_shot)
	
	steps = [
		{ "script": preload("res://scripts/tutorial/mov_tutorial.gd"), "label": "mov" },
		{ "script": preload("res://scripts/tutorial/shoot_tutorial.gd"), "label": "shoot" },
		{ "script": preload("res://scripts/tutorial/invul_tutorial.gd"), "label": "invul" },
		{ "script": preload("res://scripts/tutorial/survive_tutorial.gd"), "label": "survive" }
	]

	start_next_step()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func start_next_step():
	step_done = false  # Reset para a próxima etapa
	for label in labels.values():
		label.visible = false
	for icon in icons.values():
		icon.visible = false

	if current_script:
		current_script.queue_free()
		current_script = null

	if current_step >= steps.size():
		labels["victory"].visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://menu.tscn")  
		return

	var step = steps[current_step]
	labels[step.label].visible = true

	match step.label:
		"mov":
			icons["WASD"].visible = true
		"shoot":
			icons["Mouse"].visible = true

	current_script = step.script.new()
	current_script.controller = self

	if step.label == "survive":
		current_script.diver_enemy_scene = preload("res://scenes/diver_enemy.tscn")
		current_script.enemy_container = $EnemyContainer
		add_child(current_script)
		current_script.start_survive()
	else:
		add_child(current_script)

func tutorial_is_done():
	if step_done:
		return
	step_done = true
	current_step += 1
	start_next_step()
