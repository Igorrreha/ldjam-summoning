extends Button


@export var _game_state_signals: GameStateSignals


func _pressed() -> void:
	_game_state_signals.game_started.emit()
