extends Node


@export var _autostart: bool
@export var _current_level_idx: int = 0
@export var _levels: Array[GameLevel]

@export var _enemies_spawner: EnemiesSpawner


func _ready() -> void:
	if _autostart:
		start()


func start() -> void:
	_process_current_level()


func _process_current_level() -> void:
	var current_level = _levels[_current_level_idx]
	for wave: GameLevelWave in current_level.waves:
		_enemies_spawner.spawn_wave(wave)
		await get_tree().create_timer(wave.duration).timeout
