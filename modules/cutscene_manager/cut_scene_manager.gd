class_name CutSceneManager
extends Node

@onready var black_back: Sprite2D = $BlackBack
@onready var frame_tiles = $FrameTiles


# Called when the node enters the scene tree for the first time.
func _ready():
	show_cut_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func show_cut_scene():
	var a = 255
	while a > 0:
		await get_tree().create_timer(1.0)
		a -= 1
		black_back.modulate.a = a
