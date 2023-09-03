extends Area2D

@onready var _animation_player = $"../Sprite2D/AnimationPlayer"
@onready var _sprite = $"../Sprite2D"

func _ready():
	_animation_player.play("Level_End_Idle")
	
func interact():
	return "levelEnd"


func _on_area_entered(area):
	if area.is_in_group("Player"):
		_sprite.material.set_shader_parameter("width", 1.5)
		area.owner.startE()


func _on_area_exited(area):
	if area.is_in_group("Player"):
		_sprite.material.set_shader_parameter("width", 0)
		area.owner.endE()
