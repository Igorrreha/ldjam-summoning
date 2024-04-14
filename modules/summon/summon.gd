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


var current_target: DamageableArea2D


func _ready() -> void:
	dead.connect(on_dead)
	animation_player = $AnimationPlayer


func on_dead():
	_summon_signals.summon_dead.emit(_type, global_position)
	current_state = PlantStates.Death


func play_anim_with_state(state: PlantStates):
	match state:
		PlantStates.Idle:
			animation_player.play("idle")
		PlantStates.Spawn:
			animation_player.play("spawn")
		PlantStates.Attack:
			animation_player.play("attack")
		PlantStates.Death:
			animation_player.play("death")
			await animation_player.animation_finished
			#надо заменить удаление логикогой прехеода в собираемый объект
			queue_free()


func on_clicked() -> void:
	_summon_signals.summon_sacrificed.emit(_type, global_position)
	queue_free()


func attack():
	current_target.apply_damage(_attack_power)
	
	
func _on_attack_area_entered(area: Area2D) -> void:
	if area is DamageableArea2D:
		current_target = area
		current_state = PlantStates.Attack


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
	Spawn = 0,
	Idle = 1,
	Attack = 2,
	Death = 3
}
