extends Node2D

@onready var flying_path = get_parent()
var path_follow
@onready var _animation_player = $Daddy/AnimationPlayer
@onready var new_parent = get_node("/root/World/WalkingPath/WalkingFollowPath")

@export var _speed = 25
@export var _flying_speed = 100


var reached_end = false
var reached_flying_end = false
var startAnimationEnded = false
var walkingStarted = false
var dialogueIsPlaying = false
var dialogueIsFinished = false
# Called when the node enters the scene tree for the first time.


func _ready():
	Audio.get_node("BGHub").play()
	Audio.get_node("BGTitleScreen").stop()
	Audio.get_node("BGLevel").stop()
	if !startAnimationEnded and !reached_flying_end:
		_animation_player.play("Bat")
	
func _physics_process(delta):
	#FLYING
	if reached_flying_end and !startAnimationEnded:
		_animation_player.play("Transformation")
		await _animation_player.animation_finished
		startAnimationEnded = true
		get_parent().remove_child(self)
		new_parent.add_child(self)
		path_follow = get_parent()
		walkingStarted = true

	if !reached_flying_end:
		flying_path.set_progress(flying_path.get_progress() + _flying_speed * delta)
		
	if flying_path.get_progress_ratio() == 1:
		reached_flying_end = true
		
	#WALKING
	if walkingStarted:
		path_follow.set_progress(0)
		walkingStarted = false
	
	if !reached_end and startAnimationEnded:
		path_follow.set_progress(path_follow.get_progress() + _speed * delta)
		_animation_player.play("Walking")
		if !dialogueIsPlaying and !path_follow.get_progress_ratio() == 1:
			dialogueIsPlaying = true
			DialogueManager.showDialogueBox("res://Assets/Dialogue/StartDialogue.json")
		
		if path_follow.get_progress_ratio() == 1 and dialogueIsFinished: 
			reached_path_end.emit()
			reached_end = true
		return
			
	if reached_end and startAnimationEnded:
		_animation_player.play("Idle")
		return

signal reached_path_end
