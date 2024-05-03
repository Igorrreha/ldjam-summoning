@tool
class_name ModulesMapNodeTagView
extends PanelContainer


@export var _name: Label
@export var _remove_button: Button

var tag: ModulesMapNodeTag

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		_remove_button.pressed.connect(queue_free)


func setup(tag: ModulesMapNodeTag) -> void:
	self.tag = tag
	self.tag.about_to_destroy.connect(queue_free)
	self.tag.changed.connect(_refresh)
	
	_refresh()


func _refresh() -> void:
	var style_box = get_theme_stylebox("panel") as StyleBoxFlat
	style_box.bg_color = tag.color
	
	_name.text = tag.resource_name


func _exit_tree() -> void:
	if not _is_active:
		return
	
	tag.about_to_destroy.disconnect(queue_free)
	tag.changed.disconnect(_refresh)
