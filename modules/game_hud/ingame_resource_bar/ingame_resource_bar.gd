extends ProgressBar


@export var _ingame_resource: IngameResource


func _ready() -> void:
	_ingame_resource.value_changed.connect(_update_state.unbind(1))
	_update_state()


func _update_state() -> void:
	value = _ingame_resource.value
	min_value = _ingame_resource.min_value
	max_value = _ingame_resource.max_value
