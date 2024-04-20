@tool
class_name ModulesGraphNode
extends GraphNode


signal double_clicked


@export var _module_node_graphs_signal: ModuleNodesSignals


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			double_clicked.emit()
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_module_node_graphs_signal.module_node_right_clicked.emit(self)
