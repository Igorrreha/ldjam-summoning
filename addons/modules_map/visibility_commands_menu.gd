@tool
extends PopupMenu


signal all_nodes_showing_requested
signal selected_nodes_hiding_requested
signal not_selected_nodes_hiding_requested


func _ready() -> void:
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int) -> void:
	match id:
		CommandType.SHOW_ALL:
			all_nodes_showing_requested.emit()
		CommandType.HIDE_SELECTED:
			selected_nodes_hiding_requested.emit()
		CommandType.HIDE_NOT_SELECTED:
			not_selected_nodes_hiding_requested.emit()


enum CommandType {
	SHOW_ALL = 0,
	HIDE_SELECTED = 1,
	HIDE_NOT_SELECTED = 2,
}
