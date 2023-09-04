extends Control

@onready var _main_menu = $"../MainMenu"
@onready var _optionsButton = $"../MainMenu/Options"
@onready var _resolutionOptions = $ResolutionOptions

var resolutions = {"1280x720":Vector2(1280,720),
"1920x1080":Vector2(1920,1080),
"2560x1440":Vector2(2560,1440),
"3840x2160":Vector2(3840,2160),
"5120x1440":Vector2(5120,1440)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	AddResolutions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	_main_menu.show()
	self.hide()
	_optionsButton.grab_focus()


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func AddResolutions():
	for r in resolutions:
		_resolutionOptions.add_item(r)

func _on_resolution_options_item_selected(index):
	var size = resolutions.get(_resolutionOptions.get_item_text(_resolutionOptions.get_selected_id()))
	DisplayServer.window_set_size(size)
