@tool
extends PopupMenu


signal graph_refreshing_requested
signal graph_modules_positions_saving_requested
signal graph_modules_positions_loading_requested


func _ready() -> void:
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int) -> void:
	match id:
		CommandType.REFRESH:
			graph_refreshing_requested.emit()
		CommandType.SAVE_POSITIONS:
			graph_modules_positions_saving_requested.emit()
		CommandType.LOAD_POSITIONS:
			graph_modules_positions_loading_requested.emit()


enum CommandType {
	REFRESH = 0,
	SAVE_POSITIONS = 1,
	LOAD_POSITIONS = 2,
}
