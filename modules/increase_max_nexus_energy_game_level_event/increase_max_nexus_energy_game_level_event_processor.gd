extends GameLevelEventProcessor


@export var _session_resources: SessionResources


func process_event(event: GameLevelEvent) -> void:
	event = event as IncreaseMaxNexusEnergyGameLevelEvent
	_session_resources.nexus_energy.max_value += event.increase_amount
	_session_resources.nexus_energy.value += event.increase_amount
