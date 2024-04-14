class_name Human
extends CharacterBody2D


@export var speed: float
@export var attack_power: float
@export var damageable_area: DamageableArea2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var main_target: DamageableArea2D
var current_target: DamageableArea2D
	#set(v):
	#	current_target = v
	#	if not is_instance_valid(main_target) and not is_instance_valid(current_target) and get_overlapping_areas().is_empty():
	#		set_anim_with_state(HumanStates.stay)

var current_state = HumanStates.moving:
	set(v):
		current_state = v
		set_anim_with_state(v)


func setup(position: Vector2, target: DamageableArea2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target
	set_anim_with_state(HumanStates.moving)


func _process(delta: float) -> void:
	if current_state == HumanStates.moving and is_instance_valid(current_target):
		move_to_target(current_target)
	elif current_state == HumanStates.attack:
		pass
	else:
		current_state = HumanStates.stay


func change_target(target: DamageableArea2D):
	self.current_target = target
	current_state = HumanStates.moving


func move_to_target(target: DamageableArea2D):
	velocity = (current_target.global_position - global_position).normalized() * speed
	move_and_slide()


func attack():
	if is_instance_valid(current_target):
		current_target.apply_damage(attack_power)


func _on_attack_area_area_entered(area: Area2D) -> void:
	current_state = HumanStates.attack


func _on_detect_area_area_entered(area: Area2D) -> void:
	if area is DamageableArea2D:
		change_target(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	for overlapping_area in damageable_area.get_overlapping_areas():
		if overlapping_area is DamageableArea2D:
			change_target(overlapping_area)
			return
	
	if is_instance_valid(main_target):
		change_target(main_target)
	else:
		current_state = HumanStates.stay
		
		
func set_anim_with_state(state: HumanStates):
	match state:
		HumanStates.stay:
			animation_player.play("idle")
		HumanStates.moving:
			animation_player.play("walk")
		HumanStates.attack:
			animation_player.play("attack")


enum HumanStates
{
	stay,
	moving,
	attack,
}
