class_name Summon
extends DamageableArea2D

var animation_player: AnimationPlayer
var current_state: PlantStates:
	set(v):
		current_state = v
		play_anim_with_state(v)

@export var _type: SummonType
@export var _summon_signals: SummonsSignals
@export var _clickable_graphics: Sprite2D
@export var _attack_power: float


var attack_area: Area2D 
var current_target: DamageableArea2D


func _ready() -> void:
	dead.connect(on_dead)
	animation_player = $AnimationPlayer
	attack_area = $AttackArea
	
	
func change_attack_target(target: DamageableArea2D):
	current_state = PlantStates.ATTACK
	current_target = target


func on_dead():
	_summon_signals.summon_dead.emit(_type, global_position)
	current_state = PlantStates.DEATH


func play_anim_with_state(state: PlantStates):
	match state:
		PlantStates.IDLE:
			animation_player.play("idle")
		PlantStates.SPAWN:
			animation_player.play("spawn")
		PlantStates.ATTACK:
			animation_player.play("attack")
		PlantStates.DEATH:
			animation_player.play("death")
			await animation_player.animation_finished
			#надо заменить удаление логикогой прехеода в собираемый объект
			queue_free()


func on_clicked() -> void:
	_summon_signals.summon_sacrificed.emit(_type, global_position)
	queue_free()


func attack():
	if is_instance_valid(current_target):
		current_target.apply_damage(_attack_power)
	
	
func _on_attack_area_entered(area: Area2D) -> void:
	if current_state == PlantStates.SPAWN:
		return
	
	if area is DamageableArea2D:
		current_target = area
		current_state = PlantStates.ATTACK
		
		
func check_attack_area():
	for overlapping_area in attack_area.get_overlapping_areas():
		if overlapping_area == current_target:
			continue
	
		if overlapping_area is DamageableArea2D:
			change_attack_target(overlapping_area)
			return
			
	current_state = PlantStates.IDLE
	
	
func _on_attack_area_exited(area: Area2D) -> void:
	check_attack_area()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("destroy_summon")\
	and not is_queued_for_deletion():
		var mouse_position = get_viewport().get_mouse_position()\
			- get_canvas_transform().origin
		var click_point = mouse_position - _clickable_graphics.global_position
		if _clickable_graphics.get_rect().has_point(click_point):
			on_clicked()


enum PlantStates
{
	SPAWN = 0,
	IDLE = 1,
	ATTACK = 2,
	DEATH = 3
}
