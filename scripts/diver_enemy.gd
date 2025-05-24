extends "res://scripts/enemy.gd"

# Referência ao jogador
var player = null
# Força de perseguição (0.0 = sem perseguição, 1.0 = perseguição total)
@export var steer_strength = 1.5  # Aumentado para maior responsividade no eixo x
# Suavização da rotação para evitar tremedeira
@export var rotation_smoothing = 8.0
# Limite de influência vertical para manter a descida predominante
@export var vertical_steer_limit = 0.2  # Reduzido para menos influência vertical

func _ready():
	# Obtém o jogador do grupo "player"
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Aviso: Jogador não encontrado no grupo 'player'")
	else:
		print("Jogador encontrado em: ", player.global_position)

func _physics_process(delta):
	# Movimento base para baixo (herdado de enemy.gd)
	super._physics_process(delta)  # Chama global_position.y += speed * delta
	
	if player != null:
		# Calcula direção para o jogador
		var direction_to_player = (player.global_position - global_position).normalized()
		
		# Depuração: imprime posições e velocidade
		if randf() < 0.05:  # Imprime em 5% dos frames
			print("Inimigo: ", global_position, " | Jogador: ", player.global_position, " | Direção: ", direction_to_player)
		
		# Calcula velocidade de perseguição
		var steer_velocity = Vector2.ZERO
		# Perseguição agressiva no eixo x
		steer_velocity.x = direction_to_player.x * speed * steer_strength
		# Componente vertical limitada
		steer_velocity.y = clamp(direction_to_player.y * speed * steer_strength, 0, speed * vertical_steer_limit)
		
		# Aplica movimento de perseguição
		global_position += steer_velocity * delta
		
		# Depuração: imprime a velocidade aplicada
		if randf() < 0.05:
			print("Steer velocity: ", steer_velocity)
		
		# Rotação suave na direção do movimento
		var current_velocity = Vector2(steer_velocity.x, speed + steer_velocity.y)
		if current_velocity != Vector2.ZERO:
			var target_angle = atan2(current_velocity.y, current_velocity.x) + deg_to_rad(90)
			rotation = lerp_angle(rotation, target_angle, rotation_smoothing * delta)
	else:
		print("Jogador não encontrado durante _physics_process")
