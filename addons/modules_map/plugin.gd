@tool
extends EditorPlugin


const PLUGIN_SCENE: PackedScene = preload("res://addons/modules_map/plugin.tscn")
var _editor_base_color_style_box: StyleBoxFlat =\
	preload("res://addons/modules_map/editor_base_color_style_box.tres")
var _plugin_node: Control
var _container_type = EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU


func _enter_tree() -> void:
	var editor_settings = get_editor_interface().get_editor_settings()
	var base_color = editor_settings.get_setting("interface/theme/base_color")
	_editor_base_color_style_box.bg_color = base_color
	
	_plugin_node = PLUGIN_SCENE.instantiate() as Control
	EditorInterface.get_editor_main_screen().add_child(_plugin_node)
	_make_visible(false)


func _exit_tree() -> void:
	_plugin_node.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if _plugin_node:
		_plugin_node.visible = visible


func _get_plugin_name():
	return "ModulesMap"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme()\
		.get_icon("GraphEdit", "EditorIcons")
