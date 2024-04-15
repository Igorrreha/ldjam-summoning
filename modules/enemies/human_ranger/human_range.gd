class_name RangeEnemy
extends CharacterBody2D


@export var speed: float
@export var attack_power: float
@export var damageable_area: DamageableArea2D
@export var attack_area: Area2D
@export var detect_area: Area2D
@export var reload_time: float
var is_reloaded = false
@onready var stone_icon: Sprite2D = $StoneIcon

@export var attack_sound: AudioStream
@export var steps_sound: AudioStream
@export var death_sound: AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var look_updater: LookUpdater = $LookUpdater
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var main_target: DamageableArea2D
var current_target: DamageableArea2D

var reload_timer: Timer


var current_state = RangerStates.MOVING:
	set(v):
		current_state = v
		set_anim_with_state(v)
		
		if v == RangerStates.RELOAD:
			reload_timer.start(reload_time)
			
		if v == RangerStates.IDLE:
			stone_icon.visible = true


func setup(position: Vector2, target: DamageableArea2D):
	self.global_position = position
	self.main_target = target
	current_target = main_target
	set_anim_with_state(RangerStates.MOVING)
	reload_timer = $ReloadTimer
	reload_timer.timeout.connect(reloaded)
	
	look_updater.update_look.emit(main_target)
	
	audio_player.stream = steps_sound
	await get_tree().create_timer(randf_range(0.0, 0.5)).timeout
	audio_player.play()


func _process(delta: float) -> void:
	if current_state == RangerStates.MOVING and is_instance_valid(current_target):
		move_to_target(current_target)
	elif current_state == RangerStates.ATTACK\
	or current_state == RangerStates.DEATH\
	or current_state == RangerStates.RELOAD:
		pass
	elif current_state != RangerStates.IDLE:
		current_state = RangerStates.IDLE
		audio_player.stop()
		
		
func reloaded():
	animation_player.play("reloaded")
	await animation_player.animation_finished
	
	is_reloaded = true
	stone_icon.visible = true
	check_targets_in_detect_area()


func change_target(target: DamageableArea2D):
	look_updater.update_look.emit(target)
	self.current_target = target
	if attack_area.overlaps_area(target):
		if is_reloaded:
			current_state = RangerStates.ATTACK
	else:
		current_state = RangerStates.MOVING
		audio_player.stream = steps_sound


func move_to_target(target: DamageableArea2D):
	velocity = (current_target.global_position - global_position).normalized() * speed
	move_and_slide()


func attack():
	if is_instance_valid(current_target):
		current_target.apply_damage(attack_power)
		audio_player.stream = attack_sound
		audio_player.play()
		
	await animation_player.animation_finished
	is_reloaded = false
	current_state = RangerStates.RELOAD


func _on_attack_area_area_entered(area: Area2D) -> void:
	if current_state != RangerStates.ATTACK:
		if not is_reloaded:
			current_state = RangerStates.RELOAD
		else:
			current_state = RangerStates.ATTACK


func _on_detect_area_area_entered(area: Area2D) -> void:
	if main_target == current_target\
	and area is DamageableArea2D:
		change_target(area)


func _on_detect_area_area_exited(area: Area2D) -> void:
	if area != current_target:
		return
	
	await get_tree().process_frame
	
	check_targets_in_detect_area()


func check_targets_in_detect_area():
	for overlapping_area in detect_area.get_overlapping_areas():
		if overlapping_area is DamageableArea2D:
			change_target(overlapping_area)
			return
			
	if is_instance_valid(main_target):
		current_target = main_target
		current_state = RangerStates.MOVING
	else:
		current_state = RangerStates.IDLE


func set_anim_with_state(state: RangerStates):
	match state:
		RangerStates.IDLE:
			animation_player.play("idle")
		RangerStates.MOVING:
			animation_player.play("walk")
		RangerStates.RELOAD:
			animation_player.play("reload")
		RangerStates.ATTACK:
			animation_player.play("attack")
		RangerStates.DEATH:
			animation_player.play("death")
			audio_player.stream = death_sound
			audio_player.play()


enum RangerStates
{
	IDLE = 0,
	MOVING = 1,
	ATTACK = 2,
	RELOAD = 3,
	DEATH = 4
}


func _on_damageable_area_2d_dead() -> void:
	current_state = RangerStates.DEATH
