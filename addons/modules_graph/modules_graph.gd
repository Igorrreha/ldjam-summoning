@tool
extends GraphEdit


@export var _module_node_scene: PackedScene

var _node_name_by_module: Dictionary#[String, String]


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed()\
		and event.physical_keycode == KEY_R:
			_refresh()


func _refresh() -> void:
	clear_connections()
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
	_node_name_by_module.clear()
	
	var dependencies_provider = DependenciesProvider.new()
	var dependencies_by_module = dependencies_provider.get_dependencies()
	
	for module in dependencies_by_module:
		var module_node = _module_node_scene.instantiate() as GraphNode
		module_node.title = module
		add_child(module_node)
		
		_node_name_by_module[module] = module_node.name
		
		module_node.selected = true
	
	for module_to in dependencies_by_module:
		for module_from in dependencies_by_module[module_to]:
			var node_from = _node_name_by_module[module_from]
			var node_to = _node_name_by_module[module_to]
			connect_node(node_from, 0, node_to, 0)
	
	arrange_nodes()
	
	for child in get_children():
		if child is GraphNode:
			child.selected = false
