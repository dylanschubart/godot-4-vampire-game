extends Node2D

@onready var _sprite = $Sprite2D
@onready var _areaHit = $AreaHit

func getHit():
	_sprite.flip_v = true
	_areaHit.remove_from_group("Enemy_Damage")
	_areaHit.add_to_group("Interactables")
	print(_areaHit.get_groups())
	
func interact():
	pass
