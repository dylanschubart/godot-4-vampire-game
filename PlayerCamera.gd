extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	#if Input.is_action_just_pressed("DebugInteract"):
	#	screenshake()
	pass
	
func screenshake():
	var tween = create_tween()
	tween.tween_property(self, "offset", Vector2(-5, -5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, 5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, -5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, 5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, -5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, 5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, -5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, 5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(5, 0), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(-5, -5), 0.2)
	tween.chain().tween_property(self, "offset", Vector2(0, 0), 0.2)
	tween.play()
