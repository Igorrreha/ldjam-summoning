@tool
extends CacheManager


@export var _modules_map: ModulesMap


func store() -> void:
	super.store()
	
	var file = FileAccess.open(_cache_file_path, FileAccess.WRITE)
	for module_from in _modules_map.connections:
		var modules_to = _modules_map.connections[module_from]
		var data = [module_from, "/".join(modules_to)]
		file.store_line(",".join(data))


func restore() -> void:
	super.restore()
	
	if not FileAccess.file_exists(_cache_file_path):
		return
	
	_modules_map.connections = {}
	
	var file = FileAccess.open(_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data: Array = file.get_line().split(",")
		
		var module_from = data[0]
		var node_from = _try_get_node_by_module(module_from)
		if not node_from:
			continue
		
		_modules_map.connections[module_from] = []
		
		for module_to in data[1].split("/"):
			var node_to = _try_get_node_by_module(module_to)
			if not node_to:
				continue
			
			_modules_map.connections[module_from].append(module_to)


func _try_get_node_by_module(module: String) -> GraphNode:
	if not _modules_map.node_name_by_module.has(module):
		return null
	
	var module_to_node_name = _modules_map.node_name_by_module[module]
	if not _modules_map.has_node(module_to_node_name):
		return null
	
	return _modules_map.get_node(module_to_node_name) as GraphNode
