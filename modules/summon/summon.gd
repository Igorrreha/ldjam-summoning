extends DamageableArea2D


func _ready() -> void:
	dead.connect(on_dead)


func on_dead():
	queue_free()
