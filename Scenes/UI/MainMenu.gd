extends Control

@onready var _settings = $"../Settings"
@onready var _resolutionOptions = $"../Settings/ResolutionOptions"
@onready var buttonAudio = $"../Audio/button_click"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_start_pressed():
	buttonAudio.play()
	SceneManager.changeSceneWithTransition(SceneManager.scenes[0], false)


func _on_options_pressed():
	buttonAudio.play()
	self.hide()
	_settings.show()
	_resolutionOptions.grab_focus()

func _on_start_focus_entered():
	buttonAudio.play()


func _on_options_focus_entered():
	buttonAudio.play()


func _on_exit_focus_entered():
	buttonAudio.play()


func _on_exit_mouse_entered():
	buttonAudio.play()


func _on_options_mouse_entered():
	buttonAudio.play()


func _on_start_mouse_entered():
	buttonAudio.play()
