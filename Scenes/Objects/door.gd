extends Area2D

@export var doorNumber = 1

#Setup the animation body
@onready var _animation_player = $"../DoorTexture/AnimationPlayer"
@onready var _door = $"../DoorTexture"
@onready var _collision = $"CollisionShape2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func interact():
	return 'hubSelect - ' + str(doorNumber) 

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'Open':
		_collision.disabled = false;
		
func _on_daddy_reached_path_end():
	_animation_player.play('Open')


func _on_area_entered(area):
	if area.is_in_group("Player"):
		_door.material.set("shader_param/width", 2.5)

func _on_area_exited(area):
	if area.is_in_group("Player"):
		_door.material.set("shader_param/width", 0)
