class_name Human
extends Area2D


@export var speed: float


var target: Node2D
var is_moving = true


func setup(position: Vector2, target: Node2D):
	self.global_position = position
	self.target = target


func _process(delta: float) -> void:
	if is_moving:
		move_to_target(target)

	
func move_to_target(target: Node2D):
	global_position = global_position.move_toward(target.global_position, speed);


func _on_atack_area_area_entered(area: Area2D) -> void:
	is_moving = false
