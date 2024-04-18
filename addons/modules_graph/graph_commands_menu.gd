@tool
extends PopupMenu


signal graph_refreshing_requested


func _ready() -> void:
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int) -> void:
	match id:
		CommandType.REFRESH:
			graph_refreshing_requested.emit()


enum CommandType {
	REFRESH = 0,
}
