extends Node


@onready var _session_resources: SessionResources\
	= preload("res://modules/session_resources/session_resources.tres")


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	if event.is_pressed() and event.physical_keycode == KEY_1:
		_session_resources.nexus_energy.try_add(1)
