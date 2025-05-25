extends Node

@export var controller: Node
@export var diver_enemy_scene: PackedScene
@export var enemy_container: Node
@export var spawn_interval: float = 2.0  # tempo entre spawns

var spawning = false

func _ready():
	pass

func start_survive():
	print("início do survive")
	if not is_inside_tree():
		await tree_entered  # Aguarda até que o nó esteja na árvore
	spawning = true
	spawn_enemies_loop()

	await get_tree().create_timer(30.0).timeout
	spawning = false

	print("final do survive")
	controller.tutorial_is_done()

func spawn_enemies_loop():
	if not spawning or not is_inside_tree():
		return

	var enemy = diver_enemy_scene.instantiate()
	enemy.global_position = Vector2(randf_range(100, 1000), -100)
	enemy_container.add_child(enemy)

	await get_tree().create_timer(spawn_interval).timeout
	spawn_enemies_loop()  # recursão assíncrona enquanto `spawning` for true
