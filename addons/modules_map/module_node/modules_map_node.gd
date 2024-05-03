@tool
class_name ModulesMapNode
extends GraphNode


signal double_clicked


@export var _module_nodes_signals: ModuleNodesSignals
@export var _title_label_settings: LabelSettings

@export var _connections_to_label: Label

@export var _tags_container: Control
@export var _tag_scene: PackedScene

@export_group("Slot colors")
@export var _default_in_slot_color: Color
@export var _default_out_slot_color: Color
@export var _selected_in_slot_color: Color
@export var _selected_out_slot_color: Color


func _ready() -> void:
	for child: Label in get_titlebar_hbox().get_children():
		child.label_settings = _title_label_settings
	
	node_selected.connect(_on_selected)
	node_deselected.connect(_on_deselected)


func setup(module_name: String, tags: Array[ModulesMapNodeTag]) -> void:
	title = module_name
	
	refresh_tags(tags)


func set_connections_to_count(value: int) -> void:
	_connections_to_label.text = str(value)


func show_connections_to_count() -> void:
	_connections_to_label.show()


func hide_connections_to_count() -> void:
	_connections_to_label.hide()
	reset_size()


func get_module_name() -> String:
	return title


func refresh_tags(tags: Array[ModulesMapNodeTag]) -> void:
	for child in _tags_container.get_children():
		child.queue_free()
	
	for tag in tags:
		var tag_node = _tag_scene.instantiate() as ColorRect
		tag_node.color = tag.color
		_tags_container.add_child(tag_node)


func _on_selected() -> void:
	set_slot_color_left(0, _selected_in_slot_color)
	set_slot_color_right(0, _selected_out_slot_color)


func _on_deselected() -> void:
	set_slot_color_left(0, _default_in_slot_color)
	set_slot_color_right(0, _default_out_slot_color)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.double_click:
			double_clicked.emit()
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_module_nodes_signals.module_node_right_clicked.emit(self)
