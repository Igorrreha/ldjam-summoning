class_name PlacementPlan
extends Area2D


var place_is_valid: bool = true

signal place_become_valid
signal place_become_invalid


func _ready() -> void:
	area_entered.connect(_update_place_validity.unbind(1))
	area_exited.connect(_update_place_validity.unbind(1))
	_update_place_validity()


func _update_place_validity() -> void:
	var has_overlapping_area = not get_overlapping_areas().is_empty()
	if place_is_valid == has_overlapping_area:
		place_is_valid = not has_overlapping_area
		
		if place_is_valid:
			place_become_valid.emit()
		else:
			place_become_invalid.emit()
