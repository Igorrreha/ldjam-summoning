extends GameLevelEventProcessor


@export var _enemies_spawner: EnemiesSpawner


func process_event(event: GameLevelEvent) -> void:
	event = event as EnemiesGroupSpawnGameLevelEvent
	_enemies_spawner.spawn_wave(event.slots)
