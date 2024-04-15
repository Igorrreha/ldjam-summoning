class_name Nexus
extends DamageableArea2D


@export var _game_state_signals: GameStateSignals


func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE\
	and _health <= 0:
		_game_state_signals.game_over.emit()
