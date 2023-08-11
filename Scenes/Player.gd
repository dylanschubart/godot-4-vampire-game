extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Setup the animation body
@onready var _animated_sprite_animation = $Sprite2D/AnimationPlayer
@onready var _animated_sprite = $Sprite2D

var jumping = false;
var walking = false;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	#always flip on direction changes
	if (direction != 0): _animated_sprite.flip_h = (direction < 0); walking = true;
	#jumping animation stuff
	if (!jumping and velocity.y < 0):
		if (direction != 0): 
			_animated_sprite_animation.play("Jump_Start_Moving")
			jumping = true
			return
		else: 
			_animated_sprite_animation.play("Jump_Start_Idle")
			jumping = true
			return
	#end jumping animation
	if (jumping and is_on_floor()):
		if (_animated_sprite_animation.current_animation == 'Jump_Start_Moving'): 
			_animated_sprite_animation.play("Jump_End_Moving")
			jumping = false
			return
		else: 
			_animated_sprite_animation.play("Jump_End_Idle")
			jumping = false
			return
	#moving animation stuff or end in idle
	#if walking - and not jump end - keep checking for walk and idle
	if ((_animated_sprite_animation.is_playing() and _animated_sprite_animation.current_animation != 'Jump_End_Moving' and _animated_sprite_animation.current_animation != 'Jump_End_Idle')
	#if jump ending - check if jump end played fully - before checking for walk or idle 
	or (!_animated_sprite_animation.is_playing() and (_animated_sprite_animation.current_animation == 'Jump_End_Moving' or _animated_sprite_animation.current_animation == 'Jump_End_Idle'))
	#if we're not doing any animation & none is playing - go for a walk or idle
	or (_animated_sprite_animation.current_animation == '' and !_animated_sprite_animation.is_playing())):
		if (!jumping and walking): 
			_animated_sprite_animation.play("Walk")
			return
		if (!jumping): 
			_animated_sprite_animation.play("Idle")
