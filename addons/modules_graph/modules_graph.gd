@tool
extends GraphEdit


@export var _module_node_scene: PackedScene

var _node_name_by_module: Dictionary#[String, String]


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed()\
		and event.physical_keycode == KEY_R:
			refresh()


func _get_cache_file_path() -> String:
	return "res://addons/modules_graph/modules_data_cache.tmp"


func refresh() -> void:
	clear_connections()
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
	_node_name_by_module.clear()
	
	var dependencies_provider = DependenciesProvider.new()
	var dependencies_by_module = dependencies_provider.get_dependencies()
	
	for module in dependencies_by_module:
		var module_node = _module_node_scene.instantiate() as GraphNode
		module_node.title = module
		add_child(module_node)
		
		_node_name_by_module[module] = str(module_node.name)
		
		module_node.selected = true
	
	for module_to in dependencies_by_module:
		for module_from in dependencies_by_module[module_to]:
			var node_from = _node_name_by_module[module_from]
			var node_to = _node_name_by_module[module_to]
			connect_node(node_from, 0, node_to, 0)
	
	arrange_nodes()
	
	for child in get_children():
		if child is GraphNode:
			child.selected = false
	
	restore_positions()


func store_positions() -> void:
	var file = FileAccess.open(_get_cache_file_path(), FileAccess.WRITE)
	for module in _node_name_by_module:
		var node_name = _node_name_by_module[module]
		var node = get_node(node_name) as Control
		
		var data = [module, floori(node.position_offset.x),
			floori(node.position_offset.y)]
		file.store_line(",".join(data))


func restore_positions() -> void:
	var cache_file_path = _get_cache_file_path()
	if not FileAccess.file_exists(cache_file_path):
		return
	
	var file = FileAccess.open(cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data: Array = file.get_line().split(",")
		
		var module = data[0]
		if not _node_name_by_module.has(module):
			continue
		
		var module_node_name = _node_name_by_module[module]
		if not has_node(module_node_name):
			continue
		
		var node = get_node(module_node_name) as GraphNode
		var module_position = Vector2(float(data[1]), float(data[2]))
		node.position_offset = module_position
