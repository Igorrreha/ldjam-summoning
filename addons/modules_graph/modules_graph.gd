@tool
class_name ModulesGraph
extends GraphEdit


@export var _module_node_scene: PackedScene

@export var _modules_list_cache_manager: CacheManager
@export var _modules_connections_cache_manager: CacheManager
@export var _module_nodes_positions_cache_manager: CacheManager

var node_name_by_module: Dictionary#[String, String]
var module_by_node_name: Dictionary#[String, String]


func _ready() -> void:
	load_from_cache()


func _input(event: InputEvent) -> void:
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
	
	var dependencies_provider = DependenciesProvider.new()
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
		if child is GraphNode:
			child.selected = false
	
	_module_nodes_positions_cache_manager.restore()


func create_module_node(module: String) -> GraphNode:
	var module_node = _module_node_scene.instantiate() as GraphNode
	module_node.title = module
	add_child(module_node)
	
	node_name_by_module[module] = str(module_node.name)
	module_by_node_name[str(module_node.name)] = module
	return module_node


func _clear() -> void:
	clear_connections()
	
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
	
	node_name_by_module.clear()
	module_by_node_name.clear()
