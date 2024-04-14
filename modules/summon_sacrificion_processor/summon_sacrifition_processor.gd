extends Node


@export var _summons_signals: SummonsSignals
@export var _session_resources: SessionResources

@export var _default_meelee_summon_type: SummonType


func _ready() -> void:
	_summons_signals.summon_sacrificed.connect(_on_summon_sacrificed)


func _on_summon_sacrificed(summon_type: SummonType, position: Vector2) -> void:
	if summon_type == _default_meelee_summon_type:
		_session_resources.nexus_energy.value += 1
