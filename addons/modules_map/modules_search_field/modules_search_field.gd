@tool
extends LineEdit


@export var _modules_map: ModulesMap
@export var _result_popup_menu: PopupMenu


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	_result_popup_menu.index_pressed.connect(_on_result_popup_menu_idx_pressed)


func _on_text_submitted(new_text: String) -> void:
	var modules: Array[String]
	for module in _modules_map.node_name_by_module:
		var module_node_name = _modules_map.node_name_by_module[module]
		var module_node = _modules_map.get_node(module_node_name) as GraphNode
		
		module_node.selected = new_text in module
		if module_node.selected:
			modules.append(module)
	
	_show_result_popup_menu(modules)


func _show_result_popup_menu(modules: Array[String]) -> void:
	_result_popup_menu.clear()
	
	var rect = get_rect()
	var popup_position = global_position\
		+ Vector2(get_window().position)\
		+ Vector2(0, rect.size.y)
	var popup_size = Vector2(rect.size.x, 30)
	_result_popup_menu.popup(Rect2(popup_position, popup_size))
	
	for module in modules:
		_result_popup_menu.add_item(module)


func _on_result_popup_menu_idx_pressed(idx: int) -> void:
	var module = _result_popup_menu.get_item_text(idx)
	_modules_map.focus_on_module(module)
