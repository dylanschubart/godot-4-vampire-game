extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func screenshake():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(0.9, 0.9), 0.8)
	tween.play()
