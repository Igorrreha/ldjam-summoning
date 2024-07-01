class_name AttackingBehaviour
extends Behaviour


@export var _animation_player: AnimationPlayer

@export var _delay_between_attacks: float


func _ready() -> void:
	_animation_player.animation_finished.connect(_on_animation_finished)


func _on_activation() -> void:
	_attack()


func _on_deactivation() -> void:
	_stop_attacking()


func _on_animation_finished(animation_name: String) -> void:
	if animation_name != "attack"\
	or not _is_active:
		return
	
	await get_tree().create_timer(_delay_between_attacks).timeout
	
	_attack()


func _attack() -> void:
	_animation_player.play("attack", 0)


func _stop_attacking() -> void:
	_animation_player.stop()


func _apply_damage() -> void:
	pass
