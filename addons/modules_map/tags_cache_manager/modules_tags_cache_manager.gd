@tool
extends CacheManager


@export var _modules_map: ModulesMap
@export var _tags_storage: ModulesMapNodeTagsStorage
@export_file var _tags_cache_file_path: String


func store() -> void:
	super.store()
	
	var file = FileAccess.open(_cache_file_path, FileAccess.WRITE)
	for module in _modules_map.tags_by_module:
		var tags = _modules_map.tags_by_module[module]
		
		var tag_names = tags.map(func(x: ModulesMapNodeTag):
			return x.resource_name)
		
		var data = [module, "/".join(tag_names)]
		file.store_line(",".join(data))
	
	var tags_file = FileAccess.open(_tags_cache_file_path, FileAccess.WRITE)
	for tag in _tags_storage.tags:
		var data = [tag.resource_name, tag.color.to_html(false)]
		tags_file.store_line(",".join(data))


func restore() -> void:
	super.restore()
	
	_restore_tags()
	_restore_modules_tags()


func _restore_tags() -> void:
	_tags_storage.clear()
	
	if not FileAccess.file_exists(_tags_cache_file_path):
		return
	
	var file = FileAccess.open(_tags_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var line = file.get_line()
		if line.is_empty():
			continue
		
		var data: Array = line.split(",")
		
		var tag = ModulesMapNodeTag.new()
		tag.resource_name = data[0]
		tag.color = Color.html(data[1])
		
		_tags_storage.append(tag)


func _restore_modules_tags() -> void:
	if not FileAccess.file_exists(_cache_file_path):
		return
	
	_modules_map.tags_by_module = {}
	
	var file = FileAccess.open(_cache_file_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var line = file.get_line()
		if line.is_empty():
			continue
		
		var data: Array = line.split(",")
		
		var module = data[0]
		var tags: Array[ModulesMapNodeTag]
		_modules_map.tags_by_module[module] = tags
		
		var tags_names: Array[String]
		tags_names.assign(data[1].split("/"))
		
		tags.assign(tags_names\
			.map(func(x: String):
				return _tags_storage.get_tag_or_null(x))
			.filter(func(x: ModulesMapNodeTag):
				return x != null))
