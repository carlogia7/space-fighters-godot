extends "res://scripts/enemy.gd"

var player = null
@export var steer_strength = 1.5 
@export var rotation_smoothing = 8.0
@export var vertical_steer_limit = 0.2 

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# Movimento para baixo (herdado de enemy.gd)
	super._physics_process(delta)
	
	if player != null:
		# Direção para o jogador
		var direction_to_player = (player.global_position - global_position).normalized()
		
		var steer_velocity = Vector2.ZERO
		steer_velocity.x = direction_to_player.x * speed * steer_strength
		steer_velocity.y = clamp(direction_to_player.y * speed * steer_strength, 0, speed * vertical_steer_limit)
		
		global_position += steer_velocity * delta
		
		# Rotação
		var current_velocity = Vector2(steer_velocity.x, speed + steer_velocity.y)
		if current_velocity != Vector2.ZERO:
			var target_angle = atan2(current_velocity.y, current_velocity.x) + deg_to_rad(90)
			rotation = lerp_angle(rotation, target_angle, rotation_smoothing * delta)
	else:
		print("Jogador não encontrado")
