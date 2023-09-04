extends Node2D

@onready var _animation_player = $AnimationPlayer
@onready var MainMenu = $MainMenu
@onready var AnyKEy = $PressAnyKEy
@onready var StartButton = $MainMenu/Start

var pressedAnyKey = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_player.play("Start")
	await _animation_player.animation_finished
	_animation_player.play("PressAnyKey")
	
	
func _unhandled_input(event):
	if event is InputEventKey or event is InputEventJoypadButton and !pressedAnyKey:
		if event.pressed:
			pressedAnyKey = true
			StartButton.grab_focus()
			print("any key pressed")
			_animation_player.play("TitleScreen")
			MainMenu.show()
			StartButton.grab_focus()
			AnyKEy.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
