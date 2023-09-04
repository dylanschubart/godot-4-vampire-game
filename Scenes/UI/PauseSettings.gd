extends Control

@onready var _main_menu = $"../MainMenu"
@onready var checkbox = $CheckBox
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if DisplayServer.window_get_mode(DisplayServer.WINDOW_MODE_FULLSCREEN):
		checkbox.toggled = true
	if DisplayServer.window_get_mode(DisplayServer.WINDOW_MODE_WINDOWED):
		checkbox.toggled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	get_tree().paused = false
	get_parent().hide()


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
