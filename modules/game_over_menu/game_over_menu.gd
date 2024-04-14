extends Panel


@export var _game_state_signals: GameStateSignals


func _ready() -> void:
	_game_state_signals.game_over.connect(show)
