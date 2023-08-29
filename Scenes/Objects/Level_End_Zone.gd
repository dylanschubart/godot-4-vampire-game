extends Area2D

@onready var _animation_player = $"../Sprite2D/AnimationPlayer"

func _ready():
	_animation_player.play("Level_End_Idle")
	
func interact():
	return "levelEnd"
