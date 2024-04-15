extends Node


@export var _damageable_area: DamageableArea2D
@export var _sprite: Sprite2D


func _ready() -> void:
	_damageable_area.damaged.connect(_on_damaging)


func _on_damaging() -> void:
	var neareless_to_death = 1 - _damageable_area.get_health() / _damageable_area.get_max_health()
	_sprite.material.set_shader_parameter("_blood_amount", neareless_to_death)
