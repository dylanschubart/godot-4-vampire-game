extends Area2D

#Setup the animation body
@onready var _animation_player = $"../DoorTexture/AnimationPlayer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('DebugInteract'):
		_animation_player.play('Open')

func interact():
	return 'hubSelect'
