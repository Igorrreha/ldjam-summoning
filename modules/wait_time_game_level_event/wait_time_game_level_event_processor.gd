extends GameLevelEventProcessor


func process_event(event: GameLevelEvent) -> void:
	event = event as WaitTimeGameLevelEvent
	await get_tree().create_timer(event.time_seconds).timeout
