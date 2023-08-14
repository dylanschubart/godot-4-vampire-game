extends Node2D

@onready var path_follow = get_parent()

var _speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	path_follow.set_h_offset(path_follow.get_h_offset() + _speed * delta)
