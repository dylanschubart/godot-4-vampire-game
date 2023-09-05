extends Node2D

@onready var _animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_player.play("Start")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	await _animation_player.animation_finished
	SceneManager.changeSceneWithTransition(SceneManager.titleScreen, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
