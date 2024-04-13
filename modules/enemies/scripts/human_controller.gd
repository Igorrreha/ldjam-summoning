class_name Human
extends Area2D


@export var speed: float
@export var attack_power: float


var main_target: Node2D
var current_target: Node2D

var is_moving = true
var is_attack = false


func setup(position: Vector2, target: Node2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target


func _process(delta: float) -> void:
	if is_moving:
		move_to_target(current_target)


func change_target(target: Node2D):
	self.current_target = target
	is_moving = true


func move_to_target(target: Node2D):
	global_position = global_position.move_toward(current_target.global_position, speed);
	
	
func attack():
	print("I am attack!!")


func _on_atack_area_area_entered(area: Area2D) -> void:
	is_moving = false
	is_attack = true
	attack()


func _on_detect_area_area_entered(area: Area2D) -> void:
	change_target(area)


func _on_detect_area_exited(area: Area2D) -> void:
	for overlapping_area in get_overlapping_areas():
		pass
		
	change_target(main_target)
