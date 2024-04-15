class_name LookUpdater
extends Node2D


signal update_look(target)


@export var object_transform: Node2D

var object_node: Node2D
var look_right: bool = true


func _ready():
	update_look.connect(update_look_with_target)


func update_look_with_target(target: Node2D):
	if target.global_position.x < global_position.x and look_right:
		object_transform.transform.x *= -1
		look_right = false
	elif target.global_position.x > global_position.x and not look_right:
		object_transform.transform.x *= -1
		look_right = true
