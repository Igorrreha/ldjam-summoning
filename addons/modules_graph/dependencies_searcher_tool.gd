@tool
extends EditorScript


func _run() -> void:
	var modules_dir = "res://modules"
	var modules_dir_slices_count = modules_dir.get_slice_count("/")
	var modules = DirAccess.get_directories_at(modules_dir)
	
	var dependencies_by_module: Dictionary
	for module in modules:
		var base_modules: Dictionary
		
		var module_dir = modules_dir.path_join(module)
		for file in DirAccess.get_files_at(module_dir):
			var file_path = module_dir.path_join(file)
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
	
	for module in dependencies_by_module.keys():
		var dependencies = dependencies_by_module[module]
		if dependencies.size() == 0:
			dependencies_by_module.erase(module)
	
	print(dependencies_by_module)
