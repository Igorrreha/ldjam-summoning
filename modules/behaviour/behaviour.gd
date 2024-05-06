class_name Behaviour
extends Node


var _is_active: bool


func activate() -> void:
	if _is_active:
		return
	
	_is_active = true
	_on_activation()


func deactivate() -> void:
	if not _is_active:
		return
	
	_is_active = false
	_on_deactivation()


func _on_activation() -> void:
	pass


func _on_deactivation() -> void:
	pass


func _process(delta: float) -> void:
	if not _is_active\
	or Engine.is_editor_hint():
		return
	
	_process_behaviour(delta)


func _process_behaviour(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not _is_active\
	or Engine.is_editor_hint():
		return
	
	_physics_process_behaviour(delta)


func _physics_process_behaviour(delta: float) -> void:
	pass

