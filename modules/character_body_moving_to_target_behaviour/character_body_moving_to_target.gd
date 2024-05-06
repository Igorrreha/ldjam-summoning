class_name CharacterBodyMovingToTargetBehaviour
extends Behaviour


var _owner: CharacterBody2D
var _target: Node2D
var _moving_speed: float


func setup(owner: CharacterBody2D, target: Node2D, moving_speed: float) -> void:
	_owner = owner
	_target = target
	_moving_speed = moving_speed


func _process_behaviour(delta: float) -> void:
	_owner.velocity = (_target.global_position - _owner.global_position)\
		.normalized() * _moving_speed
	_owner.move_and_slide()
