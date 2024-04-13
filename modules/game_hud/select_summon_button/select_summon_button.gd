extends TextureButton


@export var _game_hud_signals: GameHudSignals
@export var _summon_type: SummonType


func _ready() -> void:
	button_down.connect(_on_button_down)


func _on_button_down() -> void:
	_game_hud_signals.select_summon_button_clicked.emit(_summon_type)
