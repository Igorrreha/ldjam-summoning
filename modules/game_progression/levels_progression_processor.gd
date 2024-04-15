extends Node


@export var _autostart: bool
@export var _current_level_idx: int = 0
@export var _levels: Array[GameLevel]

@export var _skip_delay: bool
@export var _first_wave_of_level_delay: float = 3

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
	_game_state_signals.level_started.emit(_current_level_idx + 1)
	
	if not _skip_delay:
		await get_tree().create_timer(_first_wave_of_level_delay).timeout
	
	for event: GameLevelEvent in current_level.events_queue:
		if _stopped:
			return
		
		if event is EnemiesGroupSpawnGameLevelEvent:
			_enemies_spawner.spawn_wave(event.slots)
		elif event is WaitTimeGameLevelEvent:
			await get_tree().create_timer(event.time_seconds).timeout
