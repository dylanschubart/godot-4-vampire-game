extends Area2D

#Setup the animation body
@onready var _animation_player = $"../DoorTexture/AnimationPlayer"
@onready var _collision = $"CollisionShape2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('DebugInteract'):
		_animation_player.play('Open')
		
func interact():
	return 'hubSelect'

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'Open':
		print(_collision.disabled)
		_collision.disabled = false;
		
