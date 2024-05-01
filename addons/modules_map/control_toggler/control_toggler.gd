@tool
extends Node


@export var _toggle_button: CheckButton
@export var _control: Control
@export var _invert: bool

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		_toggle_button.toggled.connect(_on_toggled)
		_on_toggled(_toggle_button.button_pressed)


func _on_toggled(value: bool) -> void:
	_control.set_visible.call_deferred(not value if _invert else value)
