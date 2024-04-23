@tool
extends PopupMenu


signal map_refreshing_requested
signal map_saving_requested
signal map_loading_requested
signal showing_connections_to_count_requested
signal hiding_connections_to_count_requested


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
		CommandType.SHOW_CONNECTIONS_TO_COUNT:
			var item_idx = get_item_index(id)
			toggle_item_checked(item_idx)
			
			if is_item_checked(item_idx):
				showing_connections_to_count_requested.emit()
			else:
				hiding_connections_to_count_requested.emit()


enum CommandType {
	REFRESH = 0,
	RESTORE = 1,
	STORE = 2,
	SHOW_CONNECTIONS_TO_COUNT = 3,
	HIDE_CONNECTIONS_TO_COUNT = 4,
}
