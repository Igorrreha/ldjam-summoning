@tool
extends PopupMenu


signal map_refreshing_requested
signal map_saving_requested
signal map_loading_requested


func _ready() -> void:
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int) -> void:
	match id:
		CommandType.REFRESH:
			map_refreshing_requested.emit()
		CommandType.RESTORE:
			map_loading_requested.emit()
		CommandType.STORE:
			map_saving_requested.emit()


enum CommandType {
	REFRESH = 0,
	RESTORE = 1,
	STORE = 2,
}
