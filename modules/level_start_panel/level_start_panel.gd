extends Control


@export var _skip: bool
@export var _game_state_signals: GameStateSignals
@onready var _title: Label = $Label
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_game_state_signals.level_started.connect(_on_level_started)


func _on_level_started(number: int) -> void:
	if _skip:
		return
	
	if number < 10:
		_title.text = "Level %s" % number
	else:
		_title.text = "LAST LEVEL!"
	
	_animation_player.play("show")
