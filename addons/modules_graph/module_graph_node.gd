@tool
class_name ModulesGraphNode
extends GraphNode


signal double_clicked


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
	and event.double_click:
		double_clicked.emit()
