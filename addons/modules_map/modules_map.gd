@tool
class_name ModulesMap
extends GraphEdit


@export_dir var _modules_dir: String

@export var _module_node_scene: PackedScene

@export var _modules_list_cache_manager: CacheManager
@export var _modules_connections_cache_manager: CacheManager
@export var _module_nodes_positions_cache_manager: CacheManager

var node_name_by_module: Dictionary#[String, String]
var module_by_node_name: Dictionary#[String, String]

var _is_active: bool


func _ready() -> void:
	_is_active = not "CanvasItemEditor" in str(get_path())
	
	if _is_active:
		load_from_cache()


func _input(event: InputEvent) -> void:
	if not _is_active:
		return
	
	if event is InputEventKey:
		if event.is_pressed()\
		and event.physical_keycode == KEY_R:
			refresh()


func load_from_cache() -> void:
	_clear()
	
	_modules_list_cache_manager.restore()
	_module_nodes_positions_cache_manager.restore()
	_modules_connections_cache_manager.restore()


func save_to_cache() -> void:
	_modules_list_cache_manager.store()
	_module_nodes_positions_cache_manager.store()
	_modules_connections_cache_manager.store()


func refresh() -> void:
	_clear()
	
	var dependencies_provider = ModulesDependenciesProvider.new(_modules_dir)
	var dependencies_by_module = dependencies_provider.get_dependencies()
	
	for module in dependencies_by_module:
		var module_node = create_module_node(module)
		
		module_node.selected = true
	
	for module_to in dependencies_by_module:
		for module_from in dependencies_by_module[module_to]:
			var node_from = node_name_by_module[module_from]
			var node_to = node_name_by_module[module_to]
			connect_node(node_from, 0, node_to, 0)
	
	arrange_nodes()
	
	for child in get_children():
		if child is ModulesMapNode:
			child.selected = false
	
	_module_nodes_positions_cache_manager.restore()


func create_module_node(module: String) -> GraphNode:
	var module_node = _module_node_scene.instantiate() as ModulesMapNode
	add_child(module_node)
	module_node.setup(module)
	
	module_node.double_clicked.connect(_focus_module_dir.bind(module))
	
	node_name_by_module[module] = str(module_node.name)
	module_by_node_name[str(module_node.name)] = module
	return module_node


func focus_on_module(module: String) -> void:
	var module_node = get_node(node_name_by_module[module]) as GraphNode
	scroll_offset = module_node.position_offset * zoom - get_rect().size / 2


func get_map_nodes_connected_to(to_node: GraphNode) -> Array[GraphNode]:
	var to_node_name = to_node.name
	
	var connected_nodes: Array[GraphNode]
	for connection in get_connection_list():
		if connection.to_node == to_node_name:
			var from_node_name = str(connection.from_node)
			connected_nodes.append(get_node(from_node_name))
	
	return connected_nodes


func get_map_nodes_connected_to_recursive(to_node: GraphNode) -> Array[GraphNode]:
	var nodes_to_process: Dictionary#[GraphNode, bool]
	nodes_to_process[to_node] = true
	
	var processed_nodes: Dictionary#[GraphNode, bool]
	var all_dependencies: Dictionary#[GraphNode, bool]
	
	while not nodes_to_process.is_empty():
		var processing_step_nodes = nodes_to_process.keys()
		nodes_to_process.clear()
		
		for processing_step_node: GraphNode in processing_step_nodes:
			var dependencies = get_map_nodes_connected_to(processing_step_node)
			processed_nodes[processing_step_node] = true
			
			for dependency in dependencies:
				all_dependencies[dependency] = true
				
				if not processed_nodes.has(dependency):
					nodes_to_process[dependency] = true
	
	all_dependencies.erase(to_node)
	
	var all_dependencies_array: Array[GraphNode]
	all_dependencies_array.assign(all_dependencies.keys()) 
	return all_dependencies_array


func select_dependencies_of_module(module: String, recursive = false) -> void:
	var module_node_name = node_name_by_module[module]
	var module_node = get_node(module_node_name)
	
	var dependencies = get_map_nodes_connected_to_recursive(module_node) if recursive\
		else get_map_nodes_connected_to(module_node)
	
	for node: GraphNode in dependencies:
		node.selected = true


func show_connections_to_count() -> void:
	for module in node_name_by_module:
		var module_node_name = node_name_by_module[module]
		var module_node = get_node(module_node_name)
		var connections_to_count = get_map_nodes_connected_to_recursive(module_node)\
			.size()
		module_node.set_connections_to_count(connections_to_count)
		module_node.show_connections_to_count()


func hide_connections_to_count() -> void:
	for module in node_name_by_module:
		var module_node_name = node_name_by_module[module]
		var module_node = get_node(module_node_name)
		module_node.hide_connections_to_count()


func _clear() -> void:
	clear_connections()
	
	for child in get_children():
		if child is ModulesMapNode:
			child.double_clicked.disconnect(_focus_module_dir)
			child.queue_free()
	
	node_name_by_module.clear()
	module_by_node_name.clear()


func _focus_module_dir(module: String) -> void:
	var module_path = _modules_dir.path_join(module)
	EditorInterface.get_file_system_dock().navigate_to_path(module_path)
