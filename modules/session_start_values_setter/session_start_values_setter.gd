extends Node


@export var _session_resources: SessionResources
@export var _summons_signals: SummonsSignals

@export var _locked_summons: Array[SummonType]


func _ready() -> void:
	_session_resources.nexus_energy.max_value = 1
	_session_resources.nexus_energy.value = _session_resources.nexus_energy.max_value
	
	for summon_type in _locked_summons:
		_summons_signals.summon_lock_requested.emit(summon_type)
