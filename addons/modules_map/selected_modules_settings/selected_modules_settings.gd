@tool
extends PanelContainer


@export var _modules_map: ModulesMap
@export var _names: Label
@export var _tags_contianer: Node
@export var _tag_scene: PackedScene
@export var _add_tag_button: OptionButton
@export var _tags_storage: ModulesMapNodeTagsStorage

var _is_active: bool
var _selected_modules: Array[String]
var _tag_nodes: Array[ModulesMapNodeTagView]


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		_modules_map.node_selected.connect(_refresh.unbind(1))
		_modules_map.node_deselected.connect(_refresh.unbind(1))
		_add_tag_button.item_selected.connect(_on_add_tag_button_item_selected)
		
		_tags_storage.tag_changed.connect(_refresh_add_tag_button.unbind(1))


func _refresh() -> void:
	_refresh_selected_modules()
	_refresh_names()
	_refresh_tags()
	_refresh_add_tag_button()


func _refresh_selected_modules() -> void:
	var selected_module_nodes: Array[ModulesMapNode]
	
	for child in _modules_map.get_children():
		var module_node := child as ModulesMapNode
		
		if module_node\
		and module_node.selected:
			selected_module_nodes.append(module_node)
	
	_selected_modules.assign(selected_module_nodes.map(
		func(x: ModulesMapNode):
			return x.get_module_name()))


func _refresh_names() -> void:
	_names.text = ", ".join(_selected_modules)


func _refresh_tags() -> void:
	for tag_node in _tag_nodes:
		tag_node.tree_exiting.disconnect(_on_tag_node_destroyed)
		tag_node.queue_free()
	
	_tag_nodes.clear()
	
	var common_tags: Array[ModulesMapNodeTag]
	
	for module_idx in range(_selected_modules.size()):
		var module = _selected_modules[module_idx]
		var tags = _modules_map.tags_by_module[module]\
			if _modules_map.tags_by_module.has(module)\
			else []
		
		if module_idx == 0:
			common_tags.assign(tags)
			continue
		
		common_tags.assign(common_tags.filter(
			func(x: ModulesMapNodeTag):
				return tags.has(x)))
		
		if common_tags.is_empty():
			break
	
	common_tags.sort_custom(func(x: ModulesMapNodeTag, y: ModulesMapNodeTag):
		return x.resource_name > y.resource_name)
	
	for tag in common_tags:
		var tag_node = _tag_scene.instantiate() as ModulesMapNodeTagView
		_tags_contianer.add_child(tag_node)
		tag_node.setup(tag)
		tag_node.tree_exiting.connect(_on_tag_node_destroyed.bind(tag_node))
		_tag_nodes.append(tag_node)
	
	_tags_contianer.move_child(_add_tag_button, -1)


func _refresh_add_tag_button() -> void:
	_add_tag_button.clear()
	
	for tag in _tags_storage.tags:
		_add_tag_button.add_item(tag.resource_name)


func _on_tag_node_destroyed(tag_node: ModulesMapNodeTagView) -> void:
	_tag_nodes.erase(tag_node)
	
	for module in _selected_modules:
		_modules_map.remove_tag(module, tag_node.tag)


func _on_add_tag_button_item_selected(idx: int) -> void:
	var item_id = _add_tag_button.get_item_id(idx)
	var tag_name = _add_tag_button.get_item_text(item_id) 
	
	if _tag_nodes.any(func(x: ModulesMapNodeTagView):
			return x.tag.resource_name == tag_name):
		return
	
	_add_tag(tag_name)


func _add_tag(tag_name: String) -> void:
	var tag = _tags_storage.get_tag_or_null(tag_name)
	if not tag:
		print_debug("Tag is not found %s" % tag_name)
		return
	
	for module in _selected_modules:
		_modules_map.append_tag(module, tag)
	
	_refresh_tags()
