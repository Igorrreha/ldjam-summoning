extends Path2D


@export var main_tree: Node2D
@export var human_scene: PackedScene


@onready var spawn_point: PathFollow2D = $SpawnPoint


func _ready() -> void:
	spawn_enemies(50)


func spawn_enemies(count: int):
	for i in range(count):
		spawn_point.progress_ratio = randf()
		var human = human_scene.instantiate()
		add_child(human)
		human.setup(spawn_point.global_position, main_tree)
