class_name Nexus
extends DamageableArea2D


@export var _game_state_signals: GameStateSignals
@export var audio_player: AudioStreamPlayer2D
@export var loose_game_sound: AudioStream


func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE\
	and _health <= 0:
		_game_state_signals.game_over.emit()
		audio_player.stream = loose_game_sound
		audio_player.play()
