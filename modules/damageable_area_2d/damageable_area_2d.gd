class_name DamageableArea2D
extends Area2D


signal dead
signal damaged


@export var _max_health: float = 10
@onready var _health: float = _max_health


func apply_damage(amount: float) -> void:
	_health = clamp(_health - amount, 0, _max_health)
	
	damaged.emit()
	
	if _health == 0:
		dead.emit()
