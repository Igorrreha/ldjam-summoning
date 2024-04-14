extends Node



@export var _autostart: bool
@export var _current_level_idx: int = 0
@export var _levels: Array[GameLevel]

@export var _enemies_spawner: EnemiesSpawner
@export var _game_state_signals: GameStateSignals


var _started: bool
var _stopped: bool


func _ready() -> void:
	if _autostart:
		start()
	
	_game_state_signals.game_started.connect(start)
	_game_state_signals.game_over.connect(stop)


func start() -> void:
	if _started:
		return
	
	_started = true
	_process_current_level()


func stop() -> void:
	_stopped = true


func _process_current_level() -> void:
	var current_level = _levels[_current_level_idx]
	for wave: GameLevelWave in current_level.waves:
		if _stopped:
			return
		
		_enemies_spawner.spawn_wave(wave)
		await get_tree().create_timer(wave.duration).timeout
