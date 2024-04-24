extends GameLevelEventProcessor


@export var _summons_signals: SummonsSignals


func process_event(event: GameLevelEvent) -> void:
	event = event as UnlockSummonGameLevelEvent
	_summons_signals.summon_unlock_requested.emit(event.summon_type)
