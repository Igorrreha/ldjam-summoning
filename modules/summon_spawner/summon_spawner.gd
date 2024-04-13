extends Node2D


@export var _summon_scene_by_type: Dictionary#[SummonType, PackedScene]


func spawn(type: SummonType, global_position: Vector2) -> void:
	var instance = _summon_scene_by_type[type].instantiate()
	add_child(instance)
	instance.global_position = global_position
