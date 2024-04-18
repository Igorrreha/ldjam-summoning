@tool
extends LineEdit


@export var _modules_graph: ModulesGraph


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


func _on_text_submitted(new_text: String) -> void:
	for module in _modules_graph.node_name_by_module:
		var module_node_name = _modules_graph.node_name_by_module[module]
		var module_node = _modules_graph.get_node(module_node_name) as GraphNode
		
		module_node.selected = new_text in module
