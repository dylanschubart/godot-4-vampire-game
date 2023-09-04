extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Sprite to flip
@onready var _sprite = $Sprite2D

#Areas to detect
@onready var _areaHit = $AreaHit
@onready var _areaDetection = $AreaDetection

#left & right to walk between
@onready var _left = $LeftPoint.global_position.x
@onready var _right = $RightPoint.global_position.x

#Player to be carried by
@onready var _playerHoldPos = $"../Player/HoldPosition"
@onready var _player = $"../Player"

#animation + particles
@onready var _anim_player = $Sprite2D/AnimationPlayer
@onready var _bloodspash = $BloodSplash

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
	if dead and ground:
		velocity.y += gravity * delta
		velocity.x = 0
		#perform the move	
		move_and_slide();
		
	if !dead:
		move()
		checkPoints()
		_anim_player.play("Walk")
	elif dead and !deathanim:
		deathanim = true
		_anim_player.play("Death")
		Audio.get_node("monster_death").play()
		
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
	if moving_left and global_position.x <= _left:
		_sprite.flip_h = false
		_areaDetection.scale.x = -1
		moving_left = false
		
	if !moving_left and global_position.x >= _right:
		_sprite.flip_h = true
		_areaDetection.scale.x = 1
		moving_left = true
		

func getHit():
	_areaHit.remove_from_group("Enemy_Damage")
	_areaHit.add_to_group("Interactables")
	_areaHit.add_to_group("Sacrificable")
	dead = true
	
func interact():
	carried = !carried
	if carried:
		z_index = 2
		_sprite.material.set_shader_parameter("width", 0)
		_player.endE()
	else:
		z_index = 0
		_sprite.material.set_shader_parameter("width", 1.5)
		_player.startE()
		for area in _areaHit.get_overlapping_areas():
			if area.is_in_group("Sacrifice_Area") and dead:
				sacrifice()
	
	return "enemy"

func sacrifice():
	Audio.get_node("sacrificing").play()
	_sprite.material.set_shader_parameter("width", 0)
	_player.endE()
	_areaHit.remove_from_group("Interactables")
	_bloodspash.emitting = true
	await get_tree().create_timer(3).timeout
	_player.killedEnemy()
	_player.get_node("SacrificedProgress").sacrificed()
	get_parent().remove_child(self)

func _on_area_detection_area_entered(area):
	if area.is_in_group("Player"):
		detected = true;
		
	if !carried:
		if area.is_in_group("Sacrifice_Area") and dead:
			call_deferred("sacrifice")


func _on_area_detection_area_exited(area):
	if area.is_in_group("Player"):
		detected = false;


func _on_area_hit_area_entered(area):
	if area.is_in_group("Player") and dead and _areaHit.is_in_group("Interactables"):
		_sprite.material.set_shader_parameter("width", 1.5)
		area.owner.startE()


func _on_area_hit_area_exited(area):
	if area.is_in_group("Player") and dead and _areaHit.is_in_group("Interactables"):
		_sprite.material.set_shader_parameter("width", 0)
		area.owner.endE()
