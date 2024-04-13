class_name TestPlacementPlan
extends PlacementPlan


@export var nexus_energy_cost = 1


func _check_place_validity() -> bool:
	return _session_resources.nexus_energy.value >= nexus_energy_cost\
		and super._check_place_validity()
