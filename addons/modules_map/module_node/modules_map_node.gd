@tool
class_name ModulesMapNode
extends GraphNode


signal double_clicked


@export var _module_nodes_signals: ModuleNodesSignals
@export var _title_label_settings: LabelSettings

@export var _connections_to_label: Label


func _ready() -> void:
	for child: Label in get_titlebar_hbox().get_children():
		child.label_settings = _title_label_settings


func setup(module_name: String) -> void:
	title = module_name


func set_connections_to_count(value: int) -> void:
	_connections_to_label.text = str(value)


func show_connections_to_count() -> void:
	_connections_to_label.show()


func hide_connections_to_count() -> void:
	_connections_to_label.hide()


func get_module_name() -> String:
	return title


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			double_clicked.emit()
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_module_nodes_signals.module_node_right_clicked.emit(self)
