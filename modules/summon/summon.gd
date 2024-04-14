extends DamageableArea2D

var animation_player: AnimationPlayer
var current_state: PlantStates:
	set(v):
		current_state = v
		play_anim_with_state(v)

func _ready() -> void:
	dead.connect(on_dead)
	animation_player = $AnimationPlayer


func on_dead():
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


enum PlantStates
{
	Spawn = 0,
	Idle = 1,
	Attack = 2,
	Death = 3
}
