@tool
extends CacheManager


@export var _modules_map: ModulesMap


func store() -> void:
	super.store()
	
	var file = FileAccess.open(_cache_file_path, FileAccess.WRITE)
	for module in _modules_map.node_name_by_module:
		file.store_line(module)


func restore() -> void:
	super.restore()
	
	if not FileAccess.file_exists(_cache_file_path):
		return
	
	var file = FileAccess.open(_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		_modules_map.create_module_node(file.get_line())
