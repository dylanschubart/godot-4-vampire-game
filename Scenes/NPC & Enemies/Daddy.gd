extends Node2D

@onready var flying_path = get_parent()
var path_follow
@onready var _animation_player = $Daddy/AnimationPlayer
@onready var _sprite = $Daddy
@onready var new_parent = get_node("/root/World/WalkingPath/WalkingFollowPath")
@onready var last_parent = get_node("/root/World/FlyingAwayPath/FlyingAwayPathFollow")

@export var _speed = 25
@export var _flying_speed = 100


var reached_end = false
var reached_flying_end = false
var startAnimationEnded = false
var walkingStarted = false
var dialogueIsPlaying = false
var dialogueIsFinished = false
var needToFlyAway = false
var flyingAway = false
# Called when the node enters the scene tree for the first time.


func _ready():
	#audio & animation
	Audio.get_node("BGHub").play()
	Audio.get_node("BGTitleScreen").stop()
	Audio.get_node("BGLevel").stop()
		
	if !startAnimationEnded and !reached_flying_end:
		_animation_player.play("Bat")
		
	#check level1 info
	var levelInfo = ResourceManager.getLevelInfo(0)
	if levelInfo == 9:
		DialogueManager.showDialogueBox("res://Assets/Dialogue/GoodDialogue.json")
		_animation_player.play("Idle")
		needToFlyAway = true
		dialogueIsFinished = false
	elif levelInfo != 0:
		DialogueManager.showDialogueBox("res://Assets/Dialogue/BadDialogue.json")
		
	
func _physics_process(delta):
	#flyingaway after completing the level
	if needToFlyAway and dialogueIsFinished: 
		#transform
		if _animation_player.current_animation != "Transformation":
			_animation_player.set_current_animation("Transformation")
			_animation_player.seek(_animation_player.get_current_animation_length(), true)
			_animation_player.play_backwards("Transformation")
			await _animation_player.animation_finished
			#reparent
			get_parent().remove_child(self)
			last_parent.add_child(self)
			flying_path = get_parent()
			#enable flying
			reached_flying_end = false
			needToFlyAway = false
			flyingAway = true
			#start flying animation
			_sprite.flip_v = true
			_animation_player.play("Bat")
			return
	
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
		if flyingAway:
			SceneManager.changeSceneWithTransition(SceneManager.titleScreen, false)
			flyingAway = false
		
	if needToFlyAway: 
		return	
	
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
			
	if reached_end and startAnimationEnded and !flyingAway:
		_animation_player.play("Idle")
		return

signal reached_path_end
