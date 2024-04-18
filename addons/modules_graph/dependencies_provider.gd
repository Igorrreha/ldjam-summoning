class_name DependenciesProvider
extends RefCounted


func get_dependencies() -> Dictionary:
	var modules_dir = "res://modules"
	var modules_dir_slices_count = modules_dir.get_slice_count("/")
	var modules = DirAccess.get_directories_at(modules_dir)
	
	var dependencies_by_module: Dictionary
	for module in modules:
		var base_modules: Dictionary
		
		var module_dir = modules_dir.path_join(module)
		var file_paths = _get_file_paths_from_dir_recursive(module_dir)
		for file_path in file_paths:
			var dependencies = ResourceLoader.get_dependencies(file_path)
			
			for dependency in dependencies:
				var dependency_path = dependency.get_slice("::", 2)
				
				if not dependency_path.begins_with(modules_dir):
					continue
					
				var dependency_module = dependency_path\
					.get_slice("/", modules_dir_slices_count)
				
				if dependency_module != module:
					base_modules[dependency_module] = true
		
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
