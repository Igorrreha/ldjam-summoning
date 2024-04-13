extends Node2D


signal drag_end_on_valid_place(summon_type: SummonType, position: Vector2)


@export var _game_hud_signals: GameHudSignals
@export var _placement_plan_scene_by_type: Dictionary#[SummonType, PackedScene]


var _dragging_summmon_type: SummonType
var _placement_plan: PlacementPlan


func _ready() -> void:
	_game_hud_signals.select_summon_button_clicked\
		.connect(_on_summon_drag_started)


func _process(delta: float) -> void:
	if not _dragging_summmon_type:
		return
	
	_placement_plan.global_position = get_viewport().get_mouse_position()\
		- get_canvas_transform().origin


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton\
	and event.is_released()\
	and event.button_index == MOUSE_BUTTON_LEFT:
		if _placement_plan:
			if _placement_plan.place_is_valid:
				drag_end_on_valid_place\
					.emit(_dragging_summmon_type, _placement_plan.global_position)
			_placement_plan.queue_free()
		
		_placement_plan = null
		_dragging_summmon_type = null


func _on_summon_drag_started(summon_type: SummonType) -> void:
	_dragging_summmon_type = summon_type
	_placement_plan = _placement_plan_scene_by_type[summon_type].instantiate()
	add_child(_placement_plan)
