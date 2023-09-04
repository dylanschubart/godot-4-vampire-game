extends CharacterBody2D


@export var SPEED = 150.0
@export var JUMP_VELOCITY = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Setup the animation body
@onready var _animation_player = $Sprite2D/AnimationPlayer
@onready var _sprite = $Sprite2D

#Get attack right to flip it & attackcooldown to delay attacks
@onready var _attackRight = $AttackRight
@onready var _attackUp = $AttackUp
@onready var _attackCooldown = $AttackCooldown

#Carry Position
@onready var _holdpos = $HoldPosition

#HUD element & all info
@export var health = 3
@onready var _invincibilityTimer = $InvincibilityTimer
@onready var labelE = $E
@onready var _darkness = $Darkness
@onready var _settings = $settings

var maxdarkness = 0
var hit = false
var flickerTime = 1.5

#Signal for health change
signal health_changed(value)

#Knockback vars
@export var knockback_x = 175.0
@export var knockback_y = 200.0

var jumping = false
var moving = false
var doubleJump = false
var sceneChange = false
var readyForAttack = true
var attacking = false
var knockbacked = false
var carrying = false
var levelEnding = false
var returning = false
var levelEnter = false
var dead = false

func _ready():
	get_node("Camera2D").make_current()
	

func _physics_process(delta):
	if _darkness.color.a < maxdarkness:
		_darkness.color.a += (delta / 2)
	
	#changing levels > play sit animation & nothing else
	if sceneChange or dead: 
		velocity.y += gravity * delta
		velocity.x = 0
		move_and_slide()
		if levelEnding: 
			_animation_player.play("Grab_Chalice_Idle")
		return
		
	if returning:
		if _animation_player.current_animation != "Sit":
			_animation_player.set_current_animation("Sit")
			_animation_player.seek(_animation_player.get_current_animation_length(), true)
		await SceneManager.get_node("AnimationPlayer").animation_finished
		_animation_player.play_backwards("Sit")
		return
	
	#if hit -> flicker sprite
	if hit:
		if _invincibilityTimer.time_left < flickerTime - 0.2:
			_sprite.visible = !_sprite.visible
			flickerTime -= 0.2
	else:
		_sprite.visible = true
		flickerTime = 1.5
		
	#Check if we're interacting
	if Input.is_action_just_pressed("Interact"):
		for area in $InteractionArea.get_overlapping_areas():
			if area.is_in_group('Interactables'):
				if area.has_method("interact"):
					var interaction = area.interact()
					interaction_reactor(interaction)
					return
				if area.owner.has_method("interact"):
					var interaction = area.owner.interact()
					interaction_reactor(interaction)
	
	if Input.is_action_just_pressed("Options"):
			_settings.show()
			_settings.get_node("Settings/ResolutionOptions").grab_focus()
			get_tree().paused = true
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if knockbacked:
		if is_on_floor():
			knockbacked = false
		else:
			knockback()
			return
			
	move()
	jump()
	attack()
		
	if jumping or attacking: return
	if carrying and moving: _animation_player.play("Carry_Walk"); return
	if moving: _animation_player.play("Walk"); return
	_animation_player.play("Idle")

func move():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("WalkLeft", "WalkRight")
	if direction:
		velocity.x = direction * SPEED
		moving = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		moving = false

	move_and_slide()
	#always flip on direction changes
	if (direction != 0):
		if (_holdpos.position.x < 0 and direction == 1) or (_holdpos.position.x > 0 and direction == -1): 
			_holdpos.position.x = _holdpos.position.x * -1
		_sprite.flip_h = (direction < 0);
		_attackRight.scale.x = direction

	
func jump():
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY;
		doubleJump = false
	elif Input.is_action_just_pressed("Jump") and !is_on_floor() and doubleJump == false:
		velocity.y = -JUMP_VELOCITY;
		_animation_player.play("Jump_Air")
		attacking = false
		doubleJump = true
	#jumping animation stuff
	if !jumping and velocity.y < 0:
		if moving: 
			_animation_player.play("Jump_Start_Moving")
			attacking = false
			jumping = true
#			return
		elif !moving: 
			_animation_player.play("Jump_Start_Idle")
			attacking = false
			jumping = true
#			return
	if is_on_floor():
		jumping = false

	#end jumping animation
#	if jumping and is_on_floor(): 
#		print_debug("jumping and is on floor")
#		if _animation_player.current_animation == 'Jump_Start_Moving': 
#			_animation_player.play("Jump_End_Moving")
#			print_debug("Jump End Moving is playing")
#			return
#		else: 
#			_animation_player.play("Jump_End_Idle")
#			print_debug("Jump End Idle is playing")
#			return

func attack():
	if !attacking and !carrying and readyForAttack:	
		if Input.is_action_just_pressed("Attack"):
			Audio.get_node("Slash").play()
			if Input.is_action_pressed("Aim_Up"):
				#animation
				_animation_player.play("Attack_Up")
				#hit enemy
				for area in _attackUp.get_overlapping_areas():
					if area.owner.has_method("getHit") and area.is_in_group('Enemy_Damage'):
						area.owner.getHit()
			else:
				#animation
				_animation_player.play("Attack_Right")
				#hit enemy
				for area in _attackRight.get_overlapping_areas():
					if area.owner.has_method("getHit") and area.is_in_group('Enemy_Damage'):
						area.owner.getHit()
				
			#set bools & start cooldown	
			attacking = true
			readyForAttack = false
			_attackCooldown.start()
			
func killedEnemy():
	health += 1
	emit_signal("health_changed", health)
	maxdarkness += 0.2
	
func startE():
	labelE.visible = true
	
func endE():
	labelE.visible = false
	

#AnimationPlayer Signal, if an animation finishes it sends a signal to this linked connection and we can check if specific animations have ended
func _on_animation_player_animation_finished(anim_name):
	#check if specific animations have ended
	print(anim_name)
	#if jumping animation has been played play the fall animation
	if anim_name == "Jump_Start_Moving" or anim_name == "Jump_Air" and !doubleJump:
		_animation_player.play("Jump_End_Moving")
	if anim_name == "Jump_Start_Idle" or anim_name == "Jump_Air" and !doubleJump:
		_animation_player.play("Jump_End_Idle")
	
	if anim_name == "Jump_Air" and moving:
		_animation_player.play("Jump_End_Moving")
	elif anim_name == "Jump_Air" and !moving:
		_animation_player.play("Jump_End_Idle")
		
	if anim_name == "Sit" and !returning:
		_animation_player.play("Sit_Idle")
	if returning:
		returning = false
		
	if anim_name == "Attack_Up" or anim_name == "Attack_Right":
		attacking = false
		
	if anim_name == "Grab_Chalice":
		levelEnding = true

func interaction_reactor(interaction):
	var interactionType = interaction.get_slice(' - ', 0)
	var interactionIndex = interaction.get_slice(' - ', 1)
	
	match interactionType:
		'levelSelect':
			_animation_player.play("Sit")
			SceneManager.changeSceneWithTransition(SceneManager.levels[int(interactionIndex)], true)
			SceneManager.saveCurrentSceneToLevels()
			levelEnter = true
			sceneChange = true
		'hubSelect':
			_animation_player.play("Walk")
			SceneManager.changeSceneWithTransition(SceneManager.scenes[int(interactionIndex)], false)
			sceneChange = true
		'levelEnd':
			_animation_player.play("Grab_Chalice")
			SceneManager.changeSceneWithTransition(SceneManager.levels[0], false)
			sceneChange = true
		'enemy':
			carrying = !carrying;
		_:
			print('Undefined interaction')

func _on_interaction_area_area_entered(area):
	if !hit:
		if area.is_in_group('Hazards') or area.is_in_group('Enemy_Damage'):
			health -= 1
			emit_signal("health_changed", health)
			if health == 0:
				dead = true
				_animation_player.play("Death")
				SceneManager.reloadCurrentScene()
				return
			_invincibilityTimer.start()
			hit = true
			knockback()
	if area.is_in_group('NightmareGod') and !levelEnding and !sceneChange:
		health = 0
		emit_signal("health_changed", health)
		dead = true
		_animation_player.play("Death")
		Audio.get_node("Scream").stop()
		SceneManager.reloadCurrentScene()


func _on_attack_cooldown_timeout():
	#attack cooldown expired
	readyForAttack = true


func _on_invincibility_timer_timeout():
	#hit? yes
	hit = false

func knockback():
	#knockbacked? yes
	knockbacked = true
	#setup velocity of knockback
	var knockbackDirection
	if _sprite.flip_h:
		knockbackDirection = 1
	else: 
		knockbackDirection = -1
	
	velocity.x = knockbackDirection * knockback_x
	if (is_on_floor()):
		velocity.y = -knockback_y ;
	
	#perform velocity
	move_and_slide()

#level hub
func _on_world_tree_exited():
	var doorList = [$"../Door"]
	ResourceManager.saveHub($".", $"../WalkingPath/WalkingFollowPath", doorList)


func _on_world_tree_entered():
	var doorList = [$"../Door"]
	ResourceManager.loadHub($".", $"../WalkingPath/WalkingFollowPath" , doorList)

#rooms
func _on_room_1_tree_exited():
	ResourceManager.saveRoom(0, $".", levelEnter)
	
func _on_room_1_tree_entered():
	ResourceManager.loadRoom(0, $".")
