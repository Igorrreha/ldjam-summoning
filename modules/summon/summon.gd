class_name Summon
extends DamageableArea2D


@export var _type: SummonType
@export var _summon_signals: SummonsSignals
@export var _clickable_graphics: Sprite2D


func _ready() -> void:
	dead.connect(on_dead)


func on_dead() -> void:
	_summon_signals.summon_dead.emit(_type, global_position)
	queue_free()


func on_clicked() -> void:
	_summon_signals.summon_sacrificed.emit(_type, global_position)
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("destroy_summon")\
	and not is_queued_for_deletion():
		var mouse_position = get_viewport().get_mouse_position()\
			- get_canvas_transform().origin
		var click_point = mouse_position - _clickable_graphics.global_position
		if _clickable_graphics.get_rect().has_point(click_point):
			on_clicked()
