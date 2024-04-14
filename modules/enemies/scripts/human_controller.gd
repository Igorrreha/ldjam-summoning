class_name Human
extends DamageableArea2D


@export var speed: float
@export var attack_power: float

@export var atack_timer: Timer


var main_target: DamageableArea2D
var current_target: DamageableArea2D

var is_moving = true


func setup(position: Vector2, target: DamageableArea2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target


func _process(delta: float) -> void:
	if is_moving and is_instance_valid(current_target):
		move_to_target(current_target)


func change_target(target: DamageableArea2D):
	self.current_target = target
	is_moving = true
	atack_timer.stop()


func move_to_target(target: DamageableArea2D):
	global_position = global_position.move_toward(current_target.global_position, speed)


func attack():
	if is_instance_valid(current_target):
		current_target.apply_damage(attack_power)


func _on_attack_area_area_entered(area: Area2D) -> void:
	is_moving = false
	attack()
	atack_timer.start()


func _on_detect_area_area_entered(area: Area2D) -> void:
	if area is DamageableArea2D:
		change_target(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	for overlapping_area in get_overlapping_areas():
		if overlapping_area is DamageableArea2D:
			change_target(overlapping_area)
			return
	
	if is_instance_valid(main_target):
		change_target(main_target)
	else:
		is_moving = false
		atack_timer.stop()


func _on_atack_timer_timeout() -> void:
	attack()
