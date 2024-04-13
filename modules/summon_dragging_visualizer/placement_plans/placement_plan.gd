class_name PlacementPlan
extends Area2D


@export var _session_resources: SessionResources

var place_is_valid: bool = true

signal place_become_valid
signal place_become_invalid


func _ready() -> void:
	area_entered.connect(_update_place_validity.unbind(1))
	area_exited.connect(_update_place_validity.unbind(1))
	_update_place_validity()


func _update_place_validity() -> void:
	var result_of_check = _check_place_validity()
	if place_is_valid != result_of_check:
		place_is_valid = result_of_check
		
		if place_is_valid:
			place_become_valid.emit()
		else:
			place_become_invalid.emit()


func _check_place_validity() -> bool:
	return get_overlapping_areas().is_empty()
