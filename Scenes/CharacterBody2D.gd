extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Setup the animation body
@onready var _animated_sprite = $AnimatedSprite2D
var jumping = false;

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
	if (direction > 0): _animated_sprite.flip_h = false;
	if (direction < 0): _animated_sprite.flip_h = true;
	#jumping animation stuff
	if (!jumping and velocity.y < 0):
		if (direction != 0): _animated_sprite.play("Jump_Start_Moving"); jumping = true; return;
		else: _animated_sprite.play("Jump_Start_Standstill"); jumping = true; return;
	#end jumping animation
	if (jumping and is_on_floor()):
		if (_animated_sprite.get_animation() == 'Jump_Start_Moving'): _animated_sprite.play("Jump_End_Moving"); jumping = false; return;
		else: _animated_sprite.play("Jump_End_Standstill"); jumping = false; return;
	#moving animation stuff or end in idle
	if ((_animated_sprite.is_playing() == true and _animated_sprite.get_animation() != 'Jump_End_Moving' and _animated_sprite.get_animation() != 'Jump_End_Standstill') 
	or (_animated_sprite.is_playing() != true and (_animated_sprite.get_animation() == 'Jump_End_Moving' or _animated_sprite.get_animation() == 'Jump_End_Standstill'))):
		if (!jumping and direction != 0): _animated_sprite.play("Walk"); return;
		if (!jumping ): _animated_sprite.play("Idle");
	
	
