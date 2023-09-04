extends Control

@onready var _settings = $"../Settings"
@onready var _resolutionOptions = $"../Settings/ResolutionOptions"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_start_pressed():
	SceneManager.changeSceneWithTransition(SceneManager.scenes[0], false)


func _on_options_pressed():
	self.hide()
	_settings.show()
	_resolutionOptions.grab_focus()


func _on_exit_pressed():
	get_tree().quit()
