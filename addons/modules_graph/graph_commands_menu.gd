@tool
extends PopupMenu


signal graph_refreshing_requested
signal graph_saving_requested
signal graph_loading_requested


func _ready() -> void:
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int) -> void:
	match id:
		CommandType.REFRESH:
			graph_refreshing_requested.emit()
		CommandType.RESTORE:
			graph_loading_requested.emit()
		CommandType.STORE:
			graph_saving_requested.emit()


enum CommandType {
	REFRESH = 0,
	RESTORE = 1,
	STORE = 2,
}
