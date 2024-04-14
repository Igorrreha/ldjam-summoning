extends Panel


@export var _skip: bool
@export var _start_button: Button
@export var _game_state_signals: GameStateSignals


func _ready() -> void:
	_start_button.pressed.connect(_start_game)
	
	if _skip:
		await get_tree().process_frame
		_start_game()


func _start_game() -> void:
	_game_state_signals.game_started.emit()
	hide()
