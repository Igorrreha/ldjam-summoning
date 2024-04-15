class_name Enemy
extends CharacterBody2D


@export var speed: float
@export var attack_power: float
@export var damageable_area: DamageableArea2D
@export var attack_area: Area2D
@export var detect_area: Area2D

@export var attack_sound: AudioStream
@export var steps_sound: AudioStream
@export var death_sound: AudioStream

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var look_updater: LookUpdater = $Visual/LookUpdater
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var main_target: DamageableArea2D
var current_target: DamageableArea2D

var current_state = EnemyStates.MOVING:
	set(v):
		current_state = v
		set_anim_with_state(v)


func setup(position: Vector2, target: DamageableArea2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target
	set_anim_with_state(EnemyStates.MOVING)
	look_updater.update_look.emit(main_target)
	audio_player.stream = steps_sound
	await get_tree().create_timer(randf_range(0.0, 0.5)).timeout
	audio_player.play()


func _process(delta: float) -> void:
	if current_state == EnemyStates.MOVING and is_instance_valid(current_target):
		move_to_target(current_target)
	elif current_state == EnemyStates.ATTACK\
	or current_state == EnemyStates.DEATH:
		pass
	elif current_state != EnemyStates.IDLE:
		current_state = EnemyStates.IDLE
		audio_player.stop()


func change_target(target: DamageableArea2D):
	look_updater.update_look.emit(target)
	self.current_target = target
	if attack_area.overlaps_area(target):
		current_state = EnemyStates.ATTACK
	else:
		current_state = EnemyStates.MOVING
		audio_player.stream = steps_sound


func move_to_target(target: DamageableArea2D):
	velocity = (current_target.global_position - global_position).normalized() * speed
	move_and_slide()


func attack():
	if is_instance_valid(current_target):
		audio_player.stream = attack_sound
		audio_player.play()
		current_target.apply_damage(attack_power)


func _on_attack_area_area_entered(area: Area2D) -> void:
	if current_state != EnemyStates.ATTACK:
		current_state = EnemyStates.ATTACK


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
		current_state = EnemyStates.IDLE


func set_anim_with_state(state: EnemyStates):
	match state:
		EnemyStates.IDLE:
			animation_player.play("idle")
		EnemyStates.MOVING:
			animation_player.play("walk")
		EnemyStates.ATTACK:
			animation_player.play("attack")
		EnemyStates.DEATH:
			animation_player.play("death")
			audio_player.stream = death_sound
			audio_player.play()


enum EnemyStates
{
	IDLE = 0,
	MOVING = 1,
	ATTACK = 2,
	DEATH = 3
}


func _on_damageable_area_2d_dead() -> void:
	current_state = EnemyStates.DEATH
