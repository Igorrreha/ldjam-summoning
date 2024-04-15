extends TextureButton


@export var _game_hud_signals: GameHudSignals
@export var _summon_type: SummonType

@onready var _leaves_frame: TextureRect = $LeavesFrameTexture


func _ready() -> void:
	button_down.connect(_on_button_down)
	
	mouse_entered.connect(on_focused)
	mouse_exited.connect(on_unfocused)


func _on_button_down() -> void:
	_game_hud_signals.select_summon_button_clicked.emit(_summon_type)


func on_focused():
	_leaves_frame.visible = true
	
	
func on_unfocused():
	_leaves_frame.visible = false
