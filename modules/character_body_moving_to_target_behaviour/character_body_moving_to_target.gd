class_name CharacterBodyMovingToTargetBehaviour
extends Behaviour


signal target_exit_optimal_distance
signal target_enter_optimal_distance


var _owner: CharacterBody2D
var _target: Node2D
var _moving_speed: float

@export var _max_distance: float
@export var _min_distance: float


var _target_in_optimal_distance: bool


func setup(owner: CharacterBody2D, target: Node2D, moving_speed: float) -> void:
	_owner = owner
	_target = target
	_moving_speed = moving_speed


func _on_activation() -> void:
	var vector_to_target = _target.global_position - _owner.global_position
	var distance_to_target = vector_to_target.length()
	
	var target_too_near = distance_to_target < _min_distance
	var target_too_far = distance_to_target > _max_distance
	
	if target_too_near\
	or target_too_far:
		_target_in_optimal_distance = false
		target_exit_optimal_distance.emit()
		
		return
	
	_target_in_optimal_distance = true
	target_enter_optimal_distance.emit()


func _process_behaviour(delta: float) -> void:
	var vector_to_target = _target.global_position - _owner.global_position
	var distance_to_target = vector_to_target.length()
	
	var target_too_near = distance_to_target < _min_distance
	var target_too_far = distance_to_target > _max_distance
	
	if _target_in_optimal_distance:
		if not target_too_near\
		and not target_too_far:
			return
		
		_target_in_optimal_distance = false
		target_exit_optimal_distance.emit()
	
	if not _target_in_optimal_distance:
		if not target_too_near\
		and not target_too_far:
			_target_in_optimal_distance = true
			target_enter_optimal_distance.emit()
			
			return
		
		var movement_direction = vector_to_target.normalized()\
			if target_too_far\
			else -vector_to_target.normalized()
		
		var movement_vector = movement_direction * _moving_speed
		if movement_vector.length() > vector_to_target.length():
			movement_vector = movement_direction * vector_to_target.length()
		
		_owner.velocity = movement_vector
		_owner.move_and_slide()
