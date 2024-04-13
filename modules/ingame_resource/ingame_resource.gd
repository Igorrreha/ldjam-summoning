class_name IngameResource
extends Resource


signal value_changed(new_value: float)


@export var _accuracy: float = 1.0

@export var min_value: float = 0.0
@export var max_value: float = 100.0

var value: float:
	get:
		return snappedf(value, _accuracy)
	set(v):
		value = clamp(v, min_value, max_value)
		value_changed.emit(value)


func try_spend(amount: float, ignore_limit: bool = false) -> bool:
	var new_value = value - amount
	if not ignore_limit and new_value < min_value:
		return false
	
	value = new_value
	return true


func try_add(amount: float, ignore_limit: bool = true) -> bool:
	var new_value = value - amount
	if not ignore_limit and new_value > min_value:
		return false
	
	value = new_value
	return true
