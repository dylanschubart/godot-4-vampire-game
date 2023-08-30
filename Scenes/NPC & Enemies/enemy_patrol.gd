extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Sprite to flip
@onready var _sprite = $Sprite2D

#Areas to detect
@onready var _areaHit = $AreaHit
@onready var _areaDetection = $AreaDetection

#left & right to walk between
@onready var _left = $LeftPoint
@onready var _right = $RightPoint

#Player to be carried by
@onready var _playerHoldPos = $"../Player/HoldPosition"
@onready var _player = $"../Player"

@onready var _anim_player = $Sprite2D/AnimationPlayer
#speed
@export var movement_speed = 90.0
@export var movement_speed_nearby = 120.0

var corpse = preload("res://Assets/NPC/Enemies/Crawler-CarryCorpse.png")
var deathSprite = preload("res://Assets/NPC/Enemies/Crawler-Death.png")
#checks
var moving_left = true
var dead = false
var detected = false
var carried = false
var deathanim = false
var ground = true

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
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
		ground = false

		self.position = _playerHoldPos.global_position
		
	if !carried and dead and !ground:
		ground = true
		_sprite.set_texture(deathSprite)
		_sprite.set_hframes(7)
		_sprite.set_vframes(1)
		_sprite.set_frame(6)
		self.position = _player.position

	

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
		for area in _areaHit.get_overlapping_areas():
			if area.is_in_group("Sacrifice_Area"):
				get_parent().remove_child(self)
	
	return "enemy"


func _on_area_detection_area_entered(area):
	if area.is_in_group("Player"):
		detected = true;


func _on_area_detection_area_exited(area):
	if area.is_in_group("Player"):
		detected = false;
