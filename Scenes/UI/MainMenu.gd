extends Control

@onready var _settings = $"../Settings"
@onready var _resolutionOptions = $"../Settings/ResolutionOptions"

var pressedStart = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_start_pressed():
	if !pressedStart:
		pressedStart = true
		Audio.get_node("button_click").play()
		SceneManager.changeSceneWithTransition(SceneManager.scenes[0], false)


func _on_options_pressed():
	Audio.get_node("button_click").play()
	self.hide()
	_settings.show()
	_resolutionOptions.grab_focus()

func _on_start_focus_entered():
	Audio.get_node("button_click").play()


func _on_options_focus_entered():
	Audio.get_node("button_click").play()


func _on_exit_focus_entered():
	Audio.get_node("button_click").play()


func _on_exit_mouse_entered():
	Audio.get_node("button_click").play()


func _on_options_mouse_entered():
	Audio.get_node("button_click").play()


func _on_start_mouse_entered():
	Audio.get_node("button_click").play()
