extends Control

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
func _process(_delta):
	pass

func _on_back_pressed():
	Audio.get_node("button_click").play()
	get_tree().paused = false
	get_parent().hide()


func _on_check_box_toggled(button_pressed):
	Audio.get_node("button_click").play()
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func AddResolutions():
	for r in resolutions:
		_resolutionOptions.add_item(r)

func _on_resolution_options_item_selected(_index):
	Audio.get_node("button_click").play()
	var sizeRes = resolutions.get(_resolutionOptions.get_item_text(_resolutionOptions.get_selected_id()))
	DisplayServer.window_set_size(sizeRes)
