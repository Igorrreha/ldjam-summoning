extends Node


@export var _game_container: Node
@export var _game_scene: PackedScene
@export var _game_state_signals: GameStateSignals


var _current_game_scene: Node


func _ready() -> void:
	_current_game_scene = _game_scene.instantiate()
	_game_container.add_child.call_deferred(_current_game_scene)
	_game_state_signals.game_restart_requested.connect(_restart_game)


func _restart_game() -> void:
	_current_game_scene.queue_free()
	_current_game_scene = _game_scene.instantiate()
	_game_container.add_child(_current_game_scene)
	_game_state_signals.game_started.emit()

