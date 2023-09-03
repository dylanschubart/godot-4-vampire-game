extends StaticBody2D

@onready var deadBody = $DeadBody

var enemiesleft = true

func lastEnemyKilled():
	enemiesleft = false
	deadBody.visible = false
	print(enemiesleft)

func _on_sacrifice_area_area_entered(area):
	if area.is_in_group("Player") and enemiesleft:
		deadBody.visible = true


func _on_sacrifice_area_area_exited(area):
	if area.is_in_group("Player") and enemiesleft:
		deadBody.visible = false
