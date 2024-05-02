@tool
extends FlowContainer


@export var _tags_storage: ModulesMapNodeTagsStorage
@export var _tag_editor_scene: PackedScene
@export var _create_tag_button: Button

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if not _is_active:
		return
	
	_create_tag_button.pressed.connect(_on_create_tag_button_pressed)
	
	for tag in _tags_storage.tags:
		_create_tag_editor(tag)
	
	move_child(_create_tag_button, -1)


func _on_create_tag_button_pressed() -> void:
	_create_tag_editor(_create_tag())
	move_child(_create_tag_button, -1)


func _create_tag_editor(tag: ModulesMapNodeTag) -> void:
	var tag_editor = _tag_editor_scene.instantiate() as ModulesMapNodeTagEditor
	tag_editor.setup(tag)
	
	add_child(tag_editor)


func _create_tag() -> ModulesMapNodeTag:
	var new_tag = ModulesMapNodeTag.new()
	
	var new_tag_name_template = "new_tag_%s"
	var new_tag_name_postfix = 0
	var new_tag_name = new_tag_name_template % new_tag_name_postfix
	while _tags_storage.has_tag(new_tag_name):
		new_tag_name_postfix += 1
		new_tag_name = new_tag_name_template % new_tag_name_postfix
	
	new_tag.resource_name = new_tag_name
	_tags_storage.append(new_tag)
	
	return new_tag
