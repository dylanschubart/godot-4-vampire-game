extends Node2D

@onready var _sprite = $Sprite2D
@onready var _areaHit = $AreaHit

@onready var _left = $LeftPoint
@onready var _right = $RightPoint

@export var movement_speed = 175.0
@export var movement_speed_nearby = 225.0

func _physics_process(delta):
	pass

func getHit():
	_sprite.flip_v = true
	_areaHit.remove_from_group("Enemy_Damage")
	_areaHit.add_to_group("Interactables")
	print(_areaHit.get_groups())
	
func interact():
	pass
