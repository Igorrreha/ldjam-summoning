class_name EnemiesCountProvider
extends Node


@export var _enemies_container: Node2D


func get_enemies_count() -> int:
	return _enemies_container.get_child_count()
