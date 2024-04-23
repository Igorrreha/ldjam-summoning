class_name ModulesDependenciesProvider
extends RefCounted


var _modules_dir: String

var _script_class_name_regex: RegEx
var _script_dependencies_regex: RegEx


func _init(modules_dir: String) -> void:
	_modules_dir = modules_dir
	
	_script_class_name_regex = RegEx.new()
	_script_class_name_regex.compile("class_name (([a-zA-Z_0-9])+)\\K")
	
	_script_dependencies_regex = RegEx.new()
	_script_dependencies_regex.compile("([A-Z])([a-zA-Z_0-9])+")


func get_dependencies() -> Dictionary:
	var modules_dir_slices_count = _modules_dir.get_slice_count("/")
	var modules = DirAccess.get_directories_at(_modules_dir)
	
	var files_by_module: Dictionary#[String, Array[String]]
	for module in modules:
		var module_dir = _modules_dir.path_join(module)
		files_by_module[module] = _get_file_paths_from_dir_recursive(module_dir)
	
	var custom_classes: Dictionary#[String, bool]
	var module_by_class: Dictionary#[String, String]
	for module in files_by_module:
		for file_path: String in files_by_module[module]:
			if not file_path.ends_with(".gd"):
				continue
			
			var file = FileAccess.open(file_path, FileAccess.READ)
			var script_text = file.get_as_text()
			var script_class = _get_script_class_name_or_empty(script_text)
			
			if not script_class.is_empty():
				module_by_class[script_class] = module
				custom_classes[script_class] = true
			
			file.close()
	
	var dependencies_by_module: Dictionary
	for module in modules:
		var base_modules: Dictionary
		
		var module_dir = _modules_dir.path_join(module)
		var file_paths = _get_file_paths_from_dir_recursive(module_dir)
		for file_path in file_paths:
			var resource_dependencies = ResourceLoader.get_dependencies(file_path)
			
			for dependency in resource_dependencies:
				var dependency_path = dependency.get_slice("::", 2)
				
				if not dependency_path.begins_with(_modules_dir):
					continue
				
				var dependency_module = dependency_path\
					.get_slice("/", modules_dir_slices_count)
				
				if dependency_module != module:
					base_modules[dependency_module] = true
			
			if not file_path.ends_with(".gd"):
				continue
			
			var file = FileAccess.open(file_path, FileAccess.READ)
			var script_text = file.get_as_text()
			
			var script_dependencies = _get_possible_script_dependencies(script_text)
			
			for script_dependency in script_dependencies:
				if custom_classes.has(script_dependency):
					var dependency_module = module_by_class[script_dependency]
					if dependency_module != module:
						base_modules[dependency_module] = true
			
			file.close()
		
		dependencies_by_module[module] = base_modules.keys()
	
	return dependencies_by_module


func _get_file_paths_from_dir_recursive(dir_path: String) -> Array[String]:
	var file_paths: Array[String]
	for file in DirAccess.get_files_at(dir_path):
		var file_path = dir_path.path_join(file)
		file_paths.append(file_path)
	
	for sub_dir in DirAccess.get_directories_at(dir_path):
		var sub_dir_path = dir_path.path_join(sub_dir)
		
		for file_path in _get_file_paths_from_dir_recursive(sub_dir_path):
			file_paths.append(file_path)
	
	return file_paths


func _get_script_class_name_or_empty(script_text: String) -> String:
	var search_result = _script_class_name_regex.search(script_text)
	
	if not search_result:
		return ""
	
	return search_result.strings[1]


func _get_possible_script_dependencies(script_text: String) -> Array[String]:
	var dependencies: Dictionary#[String, bool]
	var regex_matches = _script_dependencies_regex.search_all(script_text)
	for regex_match in regex_matches:
		dependencies[regex_match.get_string()] = true
	
	var dependencies_array: Array[String]
	dependencies_array.assign(dependencies.keys())
	return dependencies_array
