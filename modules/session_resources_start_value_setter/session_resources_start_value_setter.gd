extends Node


@export var _session_resources: SessionResources


func _ready() -> void:
	_session_resources.nexus_energy.max_value = 1
	_session_resources.nexus_energy.value = _session_resources.nexus_energy.max_value
