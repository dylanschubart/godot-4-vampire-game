extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Setup the animation body
@onready var _animation_player = $Sprite2D/AnimationPlayer
@onready var _sprite = $Sprite2D

#Choose health
@export var health = 3

var jumping = false
var moving = false
var doubleJump = false
var sceneChange = false


func _ready():
	pass
	

func _physics_process(delta):
	#changing levels > play sit animation & nothing else
	if sceneChange: 
		
		return
	
	#Check if we're interacting
	if Input.is_action_just_pressed("Interact"):
		for area in $Area2D.get_overlapping_areas():
			if area.has_method("interact") and area.is_in_group('Interactables'):
				var interaction = area.interact()
				interaction_reactor(interaction)
				return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move()
	jump()
	
	#moving animation stuff or end in idle
	#if moving - and not jump end - keep checking for walk and idle
#	if ((_animation_player.current_animation != 'Jump_End_Moving' and _animation_player.current_animation != 'Jump_End_Idle')
#	#if jump ending - check if jump end played fully - before checking for walk or idle 
#	or ((_animation_player.current_animation == 'Jump_End_Moving' or _animation_player.current_animation == 'Jump_End_Idle'))
#	#if we're not doing any animation & none is playing - go for a walk or idle
#	or (_animation_player.current_animation == '' and !_animation_player.is_playing())):

	if !jumping and moving:
		_animation_player.play("Walk")
	elif !jumping and !moving:
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
		_sprite.flip_h = (direction < 0)

	
func jump():
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY;
		doubleJump = false
	elif Input.is_action_just_pressed("Jump") and !is_on_floor() and doubleJump == false:
		velocity.y = -JUMP_VELOCITY;
		_animation_player.play("Jump_Air")
		doubleJump = true
	#jumping animation stuff
	if !jumping and velocity.y < 0:
		if moving: 
			_animation_player.play("Jump_Start_Moving")
			jumping = true
#			return
		elif !moving: 
			_animation_player.play("Jump_Start_Idle")
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

#AnimationPlayer Signal, if an animation finishes it sends a signal to this linked connection and we can check if specific animations have ended
func _on_animation_player_animation_finished(anim_name):
#check if specific animations have ended
	#if jumping animation has been played play the fall animation
	if anim_name == "Jump_Start_Moving" or anim_name == "Jump_Air" and !doubleJump:
		_animation_player.play("Jump_End_Moving")
	if anim_name == "Jump_Start_Idle" or anim_name == "Jump_Air" and !doubleJump:
		_animation_player.play("Jump_End_Idle")
	
	if anim_name == "Jump_Air" and moving:
		_animation_player.play("Jump_End_Moving")
	elif anim_name == "Jump_Air" and !moving:
		_animation_player.play("Jump_End_Idle")
		
	if anim_name == "Sit":
		_animation_player.play("Sit_Idle")
	#if the jump end/falling animation has been played reset to idle or walk
#	if anim_name == "Jump_End_Moving" or anim_name == "Jump_End_Idle":
#			print_debug("jumping")
#			jumping = false

func interaction_reactor(interaction):
	var interactionType = interaction.get_slice(' - ', 0)
	var interactionIndex = interaction.get_slice(' - ', 1)
	
	match interactionType:
		'levelSelect':
			_animation_player.play("Sit")
			SceneManager.changeSceneWithTransition(SceneManager.levels[int(interactionIndex)])
			SceneManager.saveCurrentSceneToLevels()
			sceneChange = true
		'hubSelect':
			_animation_player.play("Walk")
			SceneManager.changeSceneWithTransition(SceneManager.scenes[int(interactionIndex)])
			sceneChange = true
		_:
			print('Undefined interaction')


func _on_world_tree_exited():
	var doorList = [$"../Door"]
	ResourceManager.saveHub($".", $"../Daddy's path/Daddy's follow path", doorList)


func _on_world_tree_entered():
	var doorList = [$"../Door"]
	ResourceManager.loadHub($".", $"../Daddy's path/Daddy's follow path", doorList)

func _on_area_2d_area_entered(area):
	if area.is_in_group('Hazards'):
		health -= 1
		
	print(health)
