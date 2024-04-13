extends Control


signal showing_completed


func complete_showing() -> void:
	hide()
	showing_completed.emit()
