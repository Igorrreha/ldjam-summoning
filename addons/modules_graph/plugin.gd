@tool
extends EditorPlugin


const MODULES_GRAPH_SCENE: PackedScene = preload("res://addons/modules_graph/modules_graph.tscn")
var _modules_graph: GraphEdit
var _container_type = EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU


func _enter_tree() -> void:
	_modules_graph = MODULES_GRAPH_SCENE.instantiate() as GraphEdit
	EditorInterface.get_editor_main_screen().add_child(_modules_graph)
	_make_visible(false)


func _exit_tree() -> void:
	_modules_graph.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if _modules_graph:
		_modules_graph.visible = visible


func _get_plugin_name():
	return "Modules"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme()\
		.get_icon("GraphEdit", "EditorIcons")
