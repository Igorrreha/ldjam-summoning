@tool
extends PopupMenu


@export var _module_nodes_signals: ModuleNodesSignals
@export var _modules_map: ModulesMap


var _current_node: ModulesMapNode
var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if not _is_active:
		return
	
	_module_nodes_signals.module_node_right_clicked.connect(_on_popup_requested)
	id_pressed.connect(_on_id_pressed)


func _on_popup_requested(node: ModulesMapNode) -> void:
	_current_node = node
	
	var popup_position = get_mouse_position()\
		+ Vector2(get_window().position)
	var popup_size = Vector2(20, 20)
	popup(Rect2(popup_position, popup_size))


func _on_id_pressed(id: int) -> void:
	match id:
		MenuItemType.SELECT_DEPENDENCIES:
			var module = _current_node.get_module_name()
			_modules_map.select_dependencies_of_module(module)
		MenuItemType.SELECT_DEPENDENCIES_RECURSIVE:
			var module = _current_node.get_module_name()
			_modules_map.select_dependencies_of_module(module, true)
		MenuItemType.SELECT_DEPENDANTS:
			var module = _current_node.get_module_name()
			_modules_map.select_dependants_of_module(module)


enum MenuItemType {
	SELECT_DEPENDENCIES = 0,
	SELECT_DEPENDENCIES_RECURSIVE = 1,
	SELECT_DEPENDANTS = 2,
}
