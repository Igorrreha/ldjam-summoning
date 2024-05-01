@tool
extends Button


@export var _tag_scene: PackedScene

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var tag_node = _tag_scene.instantiate()
	var parent = get_parent()
	parent.add_child(tag_node)
	parent.move_child(tag_node, get_index())
