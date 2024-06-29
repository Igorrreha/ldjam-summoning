class_name DefaultMeleeEnemy
extends CharacterBody2D


@export var _moving_speed: float
@export var attack_power: float
@export var damageable_area: DamageableArea2D
@export var attack_area: Area2D
@export var _targets_detect_area: Area2D

@export var attack_sound: AudioStream
@export var steps_sound: AudioStream
@export var death_sound: AudioStream

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var look_updater: LookUpdater = $Visual/LookUpdater
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export_group("State Chart")
@export var _state_chart: StateChart
@export_subgroup("States")
@export var _target_selecting_state: StateChartState
@export var _moving_to_optimal_attack_position_state: StateChartState
@export var _attacking_state: StateChartState
@export var _death_state: StateChartState

@export_group("Behaviours")
@export var _target_selecting_behaviour: DefaultMeleeTargetSelectingBehaviour
@export var _moving_to_optimal_attack_position_behaviour: CharacterBodyMovingToTargetBehaviour


var _fallback_target: DamageableArea2D
var _target: DamageableArea2D:
	set(v):
		if _target == v:
			return
		
		_target = v
		
		_state_chart.send_event("target_found" if _target else "target_lost")


var _is_active: bool:
	set(v):
		if _is_active == v:
			return
		
		_is_active = v
		
		_state_chart.send_event("activated" if _is_active else "deactivated")


func _ready() -> void:
	_target_selecting_behaviour.target_selected.connect(_change_target)
	
	_moving_to_optimal_attack_position_behaviour.target_entered_optimal_distance\
		.connect(_on_target_entered_optimal_distance)
	_moving_to_optimal_attack_position_behaviour.target_exited_optimal_distance\
		.connect(_on_target_exited_optimal_distance)
	
	_target_selecting_state.state_entered\
		.connect(_on_target_selecting_state_entered)
	_target_selecting_state.state_exited\
		.connect(_on_target_selecting_state_exited)
	
	_moving_to_optimal_attack_position_state.state_entered\
		.connect(_on_moving_to_optimal_attack_position_state_entered)
	_moving_to_optimal_attack_position_state.state_exited\
		.connect(_on_moving_to_optimal_attack_position_state_exited)
	
	_attacking_state.state_entered\
		.connect(_on_attacking_state_entered)
	_attacking_state.state_exited\
		.connect(_on_attacking_state_exited)


func setup(position: Vector2, fallback_target: DamageableArea2D) -> void:
	self.global_position = position
	_fallback_target = fallback_target
	
	set_deferred("_is_active", true)


func _change_target(target: DamageableArea2D) -> void:
	_target = target


#region Behaviours callbacks
func _on_target_entered_optimal_distance() -> void:
	_state_chart.send_event("target_entered_optimal_distance")


func _on_target_exited_optimal_distance() -> void:
	_state_chart.send_event("target_exited_optimal_distance")
#endregion


#region States processing
func _on_target_selecting_state_entered() -> void:
	_target_selecting_behaviour.setup(self, _fallback_target, _targets_detect_area, 1)
	_target_selecting_behaviour.activate()
	
	_moving_to_optimal_attack_position_behaviour.deactivate()


func _on_target_selecting_state_exited() -> void:
	_target_selecting_behaviour.deactivate()


func _on_moving_to_optimal_attack_position_state_entered() -> void:
	if not _moving_to_optimal_attack_position_behaviour.is_active():
		_moving_to_optimal_attack_position_behaviour.setup(self, _target, _moving_speed)
		_moving_to_optimal_attack_position_behaviour.activate()


func _on_moving_to_optimal_attack_position_state_exited() -> void:
	pass


func _on_attacking_state_entered() -> void:
	if not _moving_to_optimal_attack_position_behaviour.is_active():
		_moving_to_optimal_attack_position_behaviour.setup(self, _target, _moving_speed)
		_moving_to_optimal_attack_position_behaviour.activate()


func _on_attacking_state_exited() -> void:
	pass
#endregion
