extends Node


@export var _autostart: bool
@export var _current_level_idx: int = 0

@export var _skip_delays: bool
@export var _level_start_delay: float = 3
@export var _level_end_delay: float = 3

@export var _game_state_signals: GameStateSignals
@export var _enemies_count_provider: EnemiesCountProvider

@export var _levels: Array[GameLevel]

@export var _event_processors: Dictionary#[Script, GameLevelEventProcessor]


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
	
	if not _skip_delays:
		await get_tree().create_timer(_level_start_delay).timeout
	
	for event: GameLevelEvent in current_level.events_queue:
		if _stopped:
			return
		
		var processor_path = _event_processors[event.get_script()]
		var processor = get_node(processor_path) as GameLevelEventProcessor
		await processor.process_event(event)
	
	_on_level_processing_completed()


func _on_level_processing_completed() -> void:
	while _enemies_count_provider.get_enemies_count() > 0:
		await get_tree().physics_frame
	
	if not _skip_delays:
		await get_tree().create_timer(_level_end_delay).timeout
	
	if _stopped:
		return
	
	_game_state_signals.level_completed.emit(_current_level_idx + 1)
	
	if _current_level_idx + 1 < _levels.size():
		_current_level_idx += 1
		_process_current_level()
		return
	
	_game_state_signals.game_completed.emit()
