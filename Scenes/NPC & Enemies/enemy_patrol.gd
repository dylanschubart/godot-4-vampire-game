extends CharacterBody2D


#Sprite to flip
@onready var _sprite = $Sprite2D

#Areas to detect
@onready var _areaHit = $AreaHit
@onready var _areaDetection = $AreaDetection

#left & right to walk between
@onready var _left = $LeftPoint
@onready var _right = $RightPoint

#timer to float
@onready var _floatTimer = $FloatTimer

#Player to be carried by
@onready var _playerHoldPos = $"../Player/HoldPosition"

@onready var _anim_player = $Sprite2D/AnimationPlayer
#speed
@export var movement_speed = 90.0
@export var movement_speed_nearby = 120.0

var corpse = preload("res://Assets/NPC/Enemies/Crawler-CarryCorpse.png")

#checks
var moving_left = true
var dead = false
var detected = false
var carried = false
var float_up = false
var deathanim = false

func _physics_process(_delta):
	if !dead:
		move()
		checkPoints()
		_anim_player.play("Walk")
	elif dead and !deathanim:
		deathanim = true
		_anim_player.play("Death")
		
	if carried:
		_sprite.set_texture(corpse)
		_sprite.set_hframes(1)
		_sprite.set_vframes(1)
		_sprite.set_frame(0)

		self.position = _playerHoldPos.global_position
		
	if !carried and dead and _floatTimer.is_stopped():
		_floatTimer.start()
	

func move():
	if moving_left:
		if detected: velocity.x = -movement_speed_nearby
		else: velocity.x = -movement_speed
	else:
		if detected: velocity.x = movement_speed_nearby
		else: velocity.x = movement_speed
		
	#perform the move	
	move_and_slide();

func checkPoints():
	if moving_left and position.x <= _left.position.x:
		_sprite.flip_h = false
		_areaDetection.scale.x = -1
		moving_left = false
		
	if !moving_left and position.x >= _right.position.x:
		_sprite.flip_h = true
		_areaDetection.scale.x = 1
		moving_left = true
		

func getHit():
	_areaHit.remove_from_group("Enemy_Damage")
	_areaHit.add_to_group("Interactables")
	dead = true
	
func interact():
	carried = !carried
	if carried:
		z_index = 1
	else:
		z_index = 0
		
	return "enemy"


func _on_area_detection_area_entered(area):
	if area.is_in_group("Player"):
		detected = true;


func _on_area_detection_area_exited(area):
	if area.is_in_group("Player"):
		detected = false;


func _on_float_timer_timeout():
	if float_up:
		position.y -= 1.5
		float_up = false
	else:
		position.y += 1.5
		float_up = true
