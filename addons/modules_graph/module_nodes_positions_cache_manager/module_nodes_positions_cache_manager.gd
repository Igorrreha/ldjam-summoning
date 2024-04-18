@tool
extends CacheManager


@export var _modules_graph: ModulesGraph


func store() -> void:
	super.store()
	
	var file = FileAccess.open(_cache_file_path, FileAccess.WRITE)
	for module in _modules_graph.node_name_by_module:
		var node_name = _modules_graph.node_name_by_module[module]
		var node = _modules_graph.get_node(node_name) as GraphNode
		
		var data = [module, floori(node.position_offset.x),
			floori(node.position_offset.y)]
		file.store_line(",".join(data))


func restore() -> void:
	super.restore()
	
	if not FileAccess.file_exists(_cache_file_path):
		return
	
	var file = FileAccess.open(_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data: Array = file.get_line().split(",")
		
		var module = data[0]
		if not _modules_graph.node_name_by_module.has(module):
			continue
		
		var module_node_name = _modules_graph.node_name_by_module[module]
		if not _modules_graph.has_node(module_node_name):
			continue
		
		var node = _modules_graph.get_node(module_node_name) as GraphNode
		var module_position = Vector2(float(data[1]), float(data[2]))
		node.position_offset = module_position
