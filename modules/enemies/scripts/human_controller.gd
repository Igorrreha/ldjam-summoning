class_name Human
extends Sprite2D


@export var speed: float


var target: Node2D


func _init(target: Node2D):
	self.target = target


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	move_to_target(target)

	
func move_to_target(target: Node2D):
	position.move_toward(target.position, speed);
