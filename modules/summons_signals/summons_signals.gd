class_name SummonsSignals
extends Resource


signal summon_dead(type: SummonType, position: Vector2)
signal summon_sacrificed(type: SummonType, position: Vector2)

signal summon_lock_requested(type: SummonType)
signal summon_unlock_requested(type: SummonType)
