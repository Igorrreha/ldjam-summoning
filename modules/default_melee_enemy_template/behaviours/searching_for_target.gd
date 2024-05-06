class_name DefaultMeleeTargetSelectingBehaviour
extends Behaviour


signal target_selected(target: DamageableArea2D)


var _owner: Node2D
var _scan_area: Area2D
var _rescan_timer: Timer

var _fallback_target: DamageableArea2D

var _selected_target: DamageableArea2D:
	set(v):
		if _selected_target == v:
			return
		
		_selected_target = v
		target_selected.emit(_selected_target)


func _ready() -> void:
	_rescan_timer = Timer.new()
	_rescan_timer.autostart = false
	_rescan_timer.one_shot = false
	_rescan_timer.timeout.connect(_search_for_target)
	add_child(_rescan_timer)


func setup(owner: Node2D, fallback_target: DamageableArea2D,
		scan_area: Area2D, rescan_delay: float) -> void:
	_owner = owner
	_scan_area = scan_area
	_rescan_timer.wait_time = rescan_delay
	_fallback_target = fallback_target


func _on_activation() -> void:
	_rescan_timer.start()
	_search_for_target()


func _on_deactivation() -> void:
	_rescan_timer.stop()


func _search_for_target() -> void:
	var possible_targets: Array[DamageableArea2D]
	for area in _scan_area.get_overlapping_areas():
		var damageable_area = area as DamageableArea2D
		if not damageable_area:
			continue
		
		possible_targets.append(damageable_area)
	
	if not possible_targets.is_empty():
		_selected_target = possible_targets.reduce(_get_nearest_node, possible_targets[0])
		return
	
	if _fallback_target:
		_selected_target = _fallback_target


func _get_nearest_node(a: Node2D, b: Node2D) -> Node2D:
	var distance_a = a.global_position.distance_to(_owner.global_position)
	var distance_b = b.global_position.distance_to(_owner.global_position)
	return a\
		if distance_a < distance_b\
		else b
