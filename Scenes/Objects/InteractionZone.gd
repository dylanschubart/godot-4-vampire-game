extends Area2D

@export var levelNumber = 1
@onready var _body = $"../Body"

func interact():
	return 'levelSelect - ' + str(levelNumber)


func _on_area_entered(area):
	if area.is_in_group("Player"):
		_body.material.set_shader_parameter("width", 1.5)
		area.owner.startE()


func _on_area_exited(area):
	if area.is_in_group("Player"):
		_body.material.set_shader_parameter("width", 0)
		area.owner.endE()
