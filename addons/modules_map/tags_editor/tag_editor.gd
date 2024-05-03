@tool
class_name ModulesMapNodeTagEditor
extends PanelContainer


@export var _name: LineEdit
@export var _color_picker: ColorPickerButton
@export var _tags_storage: ModulesMapNodeTagsStorage

var _is_active: bool
var _tag: ModulesMapNodeTag


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		_name.text_submitted.connect(_on_name_edit_finished.unbind(1))
		_name.focus_exited.connect(_on_name_edit_finished)
		_color_picker.color_changed.connect(_on_color_changed)


func setup(tag: ModulesMapNodeTag) -> void:
	_tag = tag
	_name.text = _tag.resource_name
	_color_picker.color = _tag.color


func _on_name_edit_finished() -> void:
	if _name.text.is_empty():
		queue_free()
		_tags_storage.remove(_tag)
		return
	
	_tag.resource_name = _name.text
	_tag.emit_changed()


func _on_color_changed(new_color: Color) -> void:
	_tag.color = new_color
	_tag.emit_changed()
