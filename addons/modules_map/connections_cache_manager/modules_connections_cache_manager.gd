@tool
extends CacheManager


@export var _modules_map: ModulesMap


func store() -> void:
	super.store()
	
	var connections: Dictionary#[String, Array[String]]
	for module in _modules_map.node_name_by_module:
		connections[module] = []
	
	for connection in _modules_map.get_connection_list():
		var module_to = _modules_map.module_by_node_name[connection.to_node]
		var module_from = _modules_map.module_by_node_name[connection.from_node]
		connections[module_to].append(module_from)
	
	var file = FileAccess.open(_cache_file_path, FileAccess.WRITE)
	for module_to in connections:
		var modules_from = connections[module_to]
		var data = [module_to, "/".join(modules_from)]
		file.store_line(",".join(data))


func restore() -> void:
	super.restore()
	
	if not FileAccess.file_exists(_cache_file_path):
		return
	
	var file = FileAccess.open(_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data: Array = file.get_line().split(",")
		
		var module_to = data[0]
		var node_to = _try_get_node_by_module(module_to)
		if not node_to:
			continue
		
		for module_from in data[1].split("/"):
			var node_from = _try_get_node_by_module(module_from)
			if not node_from:
				continue
			
			_modules_map.connect_node(node_from.name, 0, node_to.name, 0)


func _try_get_node_by_module(module: String) -> GraphNode:
	if not _modules_map.node_name_by_module.has(module):
		return null
	
	var module_to_node_name = _modules_map.node_name_by_module[module]
	if not _modules_map.has_node(module_to_node_name):
		return null
	
	return _modules_map.get_node(module_to_node_name) as GraphNode
