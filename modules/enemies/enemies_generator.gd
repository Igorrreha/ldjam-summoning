class_name EnemiesSpawner
extends Path2D


@export var _main_tree: DamageableArea2D
@export var _enemies_container: Node2D
@export var _enemy_scene_by_type: Dictionary#[EnemyType, PackedScene]

@onready var _spawn_point: PathFollow2D = $SpawnPoint


func spawn_wave(group: Array[EnemiesGroupSlot]) -> void:
	var wave_position = _get_random_spawn_position()
	var moving_angle = _main_tree.global_position.angle_to(wave_position)
	for slot: EnemiesGroupSlot in group:
		var spawn_position = slot.position.rotated(moving_angle)
		_spawn_enemy(slot.enemy_type, wave_position - spawn_position)


func spawn_enemies(count: int):
	for i in range(count):
		var spawn_position = _get_random_spawn_position()
		_spawn_enemy(_enemy_scene_by_type.keys()[0], spawn_position)


func _spawn_enemy(enemy_type: EnemyType, position: Vector2) -> void:
	var enemy = _enemy_scene_by_type[enemy_type].instantiate()
	_enemies_container.add_child(enemy)
	enemy.setup(position, _main_tree)


func _get_random_spawn_position() -> Vector2:
	_spawn_point.progress_ratio = randf()
	return _spawn_point.global_position
