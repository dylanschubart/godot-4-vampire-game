extends Node2D

@onready var path_follow = get_parent()
@onready var _animation_player = $Daddy/AnimationPlayer

@export var _speed = 25

var reached_end = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !reached_end:
		_animation_player.play("Walking")
		if path_follow.get_progress_ratio() == 1: 
			reached_path_end.emit()
			reached_end = true
			return
	else:
		_animation_player.play("Idle")
	
	path_follow.set_progress(path_follow.get_progress() + _speed * delta)

signal reached_path_end
