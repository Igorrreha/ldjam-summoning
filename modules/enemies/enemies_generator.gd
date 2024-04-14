class_name EnemiesSpawner
extends Path2D


@export var main_tree: DamageableArea2D
@export var _enemy_scene_by_type: Dictionary#[EnemyType, PackedScene]


@onready var spawn_point: PathFollow2D = $SpawnPoint


#func _ready() -> void:
	#spawn_enemies(10)


func spawn_wave(wave: GameLevelWave) -> void:
	var wave_position = _get_random_spawn_position()
	var moving_angle = main_tree.global_position.angle_to(wave_position)
	for slot: GameLevelWaveSlot in wave.slots:
		var spawn_position = slot.position.rotated(moving_angle)
		_spawn_enemy(slot.enemy_type, wave_position - spawn_position)


func spawn_enemies(count: int):
	for i in range(count):
		var spawn_position = _get_random_spawn_position()
		_spawn_enemy(_enemy_scene_by_type.keys()[0], spawn_position)


func _spawn_enemy(enemy_type: EnemyType, position: Vector2) -> void:
	var enemy = _enemy_scene_by_type[enemy_type].instantiate()
	add_child(enemy)
	enemy.setup(position, main_tree)


func _get_random_spawn_position() -> Vector2:
	spawn_point.progress_ratio = randf()
	return spawn_point.global_position
