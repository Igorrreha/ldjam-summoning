@tool
extends LineEdit

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		text_submitted.connect(_on_edit_finished.unbind(1))
		focus_exited.connect(_on_edit_finished)


func _on_edit_finished() -> void:
	if text.is_empty():
		queue_free()
