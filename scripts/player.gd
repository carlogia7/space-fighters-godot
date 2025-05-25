class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
@export var speed = 300
@onready var saida_tiro = $Muzzle
@onready var sprite = $Sprite2D
@onready var cooldown_bar = get_cooldown_bar()
@onready var invul_sound = $InvulSound

var laser_scene = preload("res://scenes/laser.tscn")

var shoot_cooldown := false

# Variáveis: Invulnerabilidade
var is_invulnerable = false
var invuln_time_max := 2.0
var invuln_timer := 0.0
var cooldown_max := 10.0
var cooldown_timer := 10.0  # começa carregada

func get_cooldown_bar():
	var scene_name = get_tree().current_scene.name
	var hud_path = "%s/HUD/CooldownBar" % scene_name
	if get_tree().root.has_node(hud_path):
		return get_tree().root.get_node(hud_path)
	else:
		print("CooldownBar não encontrado em: ", hud_path)
		return null

func _process(delta):
	# Tiro
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot()
			await get_tree().create_timer(0.25).timeout
			shoot_cooldown = false
	# Invulnerabilidade
	handle_invulnerability(delta)

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left","move_right"), 
	Input.get_axis("move_up","move_down"))
	velocity = direction * speed
	move_and_slide()	
	#global_position = global_position.clamp(Vector2.ZERO,get_viewport_rect().size)
	
	
func shoot():
	laser_shot.emit(laser_scene, saida_tiro.global_position)

# Função: Invulnerabilidade
func handle_invulnerability(delta):
	# Atualiza barra
	if cooldown_bar:
		cooldown_bar.value = cooldown_timer

	# Atualiza timers
	if cooldown_timer < cooldown_max:
		cooldown_timer += delta

	if is_invulnerable:
		invuln_timer += delta
		if invuln_timer >= invuln_time_max:
			end_invulnerability()

	# Ativação por tecla
	if Input.is_action_pressed("invul") and cooldown_timer >= cooldown_max:
		if !is_invulnerable:
			start_invulnerability()

func start_invulnerability():
	invul_sound.play()
	is_invulnerable = true
	invuln_timer = 0.0
	cooldown_timer = 0.0
	sprite.modulate.a = 0.5  # torna o player translúcido (efeito visual)

func end_invulnerability():
	is_invulnerable = false
	invuln_timer = 0.0
	sprite.modulate.a = 1.0  # volta ao normal
	
func die():
	queue_free()
