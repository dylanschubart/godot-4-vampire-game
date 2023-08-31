extends CanvasLayer

@onready var _player = $".."
@onready var _progressBar = $HealthUIEmpty/TextureProgressBar
var current_value = 3
var max_value = 6

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
			_progressBar.value = current_value
	elif current_value <= 0:
		_progressBar.visible = false
