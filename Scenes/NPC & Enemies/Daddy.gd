extends Node2D

@onready var path_follow = get_parent()

@export var _speed = 25

var reached_end = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !reached_end:
		if path_follow.get_progress_ratio() == 1: 
			reached_path_end.emit()
			reached_end = true
			return
	
	path_follow.set_progress(path_follow.get_progress() + _speed * delta)

signal reached_path_end
