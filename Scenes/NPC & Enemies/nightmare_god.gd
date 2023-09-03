extends CharacterBody2D

const SPEED = 30.0

@onready var _player = get_tree().current_scene .get_node("Player")
@onready var _animationplayer = $Sprite2D/AnimationPlayer
@onready var _sprite = $Sprite2D

func _ready():
	_animationplayer.play("Nightmare_Flying")

func _physics_process(delta):
	_sprite.flip_h = _player.global_position.x < global_position.x
	
	velocity = global_position.direction_to(_player.global_position)
	move_and_collide(velocity * SPEED * delta)
