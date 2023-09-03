extends StaticBody2D

@onready var deadBody = $DeadBody

func _on_sacrifice_area_area_entered(area):
	if area.is_in_group("Player"):
		deadBody.visible = true


func _on_sacrifice_area_area_exited(area):
	if area.is_in_group("Player"):
		deadBody.visible = false
