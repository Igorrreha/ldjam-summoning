class_name Human
extends CharacterBody2D


@export var speed: float
@export var attack_power: float
@export var damageable_area: DamageableArea2D
@export var attack_area: Area2D
@export var detect_area: Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var main_target: DamageableArea2D
var current_target: DamageableArea2D

var current_state = HumanStates.MOVING:
	set(v):
		current_state = v
		set_anim_with_state(v)


func setup(position: Vector2, target: DamageableArea2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target
	set_anim_with_state(HumanStates.MOVING)


func _process(delta: float) -> void:
	if current_state == HumanStates.MOVING and is_instance_valid(current_target):
		move_to_target(current_target)
	elif current_state == HumanStates.ATTACK\
	or current_state == HumanStates.DEATH:
		pass
	elif current_state != HumanStates.IDLE:
		current_state = HumanStates.IDLE


func change_target(target: DamageableArea2D):
	self.current_target = target
	if attack_area.overlaps_area(target):
		current_state = HumanStates.ATTACK
	else:
		current_state = HumanStates.MOVING


func move_to_target(target: DamageableArea2D):
	velocity = (current_target.global_position - global_position).normalized() * speed
	move_and_slide()


func attack():
	if is_instance_valid(current_target):
		current_target.apply_damage(attack_power)


func _on_attack_area_area_entered(area: Area2D) -> void:
	if current_state != HumanStates.ATTACK:
		current_state = HumanStates.ATTACK


func _on_detect_area_area_entered(area: Area2D) -> void:
	if main_target == current_target\
	and area is DamageableArea2D:
		change_target(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	if area != current_target:
		return
	
	await get_tree().process_frame
	
	for overlapping_area in detect_area.get_overlapping_areas():
		if overlapping_area is DamageableArea2D:
			change_target(overlapping_area)
			return
	
	if is_instance_valid(main_target):
		change_target(main_target)
	else:
		current_state = HumanStates.IDLE


func set_anim_with_state(state: HumanStates):
	match state:
		HumanStates.IDLE:
			animation_player.play("idle")
		HumanStates.MOVING:
			animation_player.play("walk")
		HumanStates.ATTACK:
			animation_player.play("attack")
		HumanStates.DEATH:
			animation_player.play("death")


enum HumanStates
{
	IDLE = 0,
	MOVING = 1,
	ATTACK = 2,
	DEATH = 3
}


func _on_damageable_area_2d_dead() -> void:
	current_state = HumanStates.DEATH
