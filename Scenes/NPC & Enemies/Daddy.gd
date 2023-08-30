extends Node2D

@onready var flying_path = get_parent()
var path_follow
@onready var _animation_player = $Daddy/AnimationPlayer
@onready var new_parent = get_node("/root/World/WalkingPath/WalkingFollowPath")

@export var _speed = 25


var reached_end = false
var reached_fyling_end = false
var start_anim = false
# Called when the node enters the scene tree for the first time.


func _ready():
	print(new_parent)
	if !start_anim and !reached_fyling_end:
		_animation_player.play("Bat")
	
func _physics_process(delta):
	if reached_fyling_end and !start_anim:
		_animation_player.play("Transformation")
		await _animation_player.animation_finished
		start_anim = true
		get_parent().remove_child(self)
		new_parent.add_child(self)
		path_follow = get_parent()
	
	if !reached_end and start_anim:
		path_follow.set_progress(path_follow.get_progress() + _speed * delta)
		_animation_player.play("Walking")
		if path_follow.get_progress_ratio() == 1: 
			reached_path_end.emit()
			reached_end = true
			return
	elif start_anim:
		_animation_player.play("Idle")
	elif !reached_fyling_end:
		flying_path.set_progress(flying_path.get_progress() + _speed * delta)
	if flying_path.get_progress_ratio() == 1:
		reached_fyling_end = true

signal reached_path_end
