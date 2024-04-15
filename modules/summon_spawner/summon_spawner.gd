extends Node2D


@export var _session_resources: SessionResources
@export var _summon_scene_by_type: Dictionary#[SummonType, PackedScene]


func spawn(type: SummonType, placement_plan: PlacementPlan,
		global_position: Vector2) -> void:
	var instance = _summon_scene_by_type[type].instantiate()
	add_child(instance)
	instance.global_position = global_position
	
	if placement_plan is StandartSummonPlacementPlan:
		_session_resources.nexus_energy\
			.try_spend(placement_plan.nexus_energy_cost, true)
	elif placement_plan is RangeSummonPlacementPlan:
		_session_resources.nexus_energy\
			.try_spend(placement_plan.nexus_energy_cost, true)
	
