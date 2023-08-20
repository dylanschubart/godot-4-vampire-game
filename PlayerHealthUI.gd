extends CanvasLayer

var max_value = 3
var current_value = 3
@onready var _player = $".."
@onready var _healthFull = $HealthUIFull

# Called when the node enters the scene tree for the first time.
func _ready():
	if _player != null:
		if _player.health > max_value:
			visible = false
		else:
			_player.health_changed.connect(change_texture)
		

func change_texture(value):
	current_value = value
	if current_value > 0:
		if current_value <= max_value:
			_healthFull.size.x = current_value * 16
	elif current_value <= 0:
		_healthFull.visible = false
