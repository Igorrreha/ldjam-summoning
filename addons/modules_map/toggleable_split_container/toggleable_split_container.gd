@tool
extends HSplitContainer


@export var _toggle_button: CheckButton

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		_toggle_button.toggled.connect(_on_toggled)
		_on_toggled(_toggle_button.button_pressed)


func _on_toggled(value: bool) -> void:
	collapsed = value
	if collapsed:
		dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED
	else:
		dragger_visibility = SplitContainer.DRAGGER_VISIBLE
