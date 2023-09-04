extends StaticBody2D

#UI
@onready var deadBody = $DeadBody

#check kills
var enemiesleft = true

#spawn the nightmaregod on max kills
var nightmare_god = preload("res://Scenes/NPC & Enemies/nightmare_god.tscn")

func _ready():
	Audio.get_node("BGHub").stop()
	Audio.get_node("BGTitleScreen").stop()
	Audio.get_node("BGLevel").play()

func lastEnemyKilled():
	enemiesleft = false
	deadBody.visible = false
	get_tree().current_scene.get_node("Player/Camera2D").screenshake()
	var spawn = nightmare_god.instantiate()
	add_child(spawn)

func _on_sacrifice_area_area_entered(area):
	if area.is_in_group("Player") and enemiesleft:
		deadBody.visible = true


func _on_sacrifice_area_area_exited(area):
	if area.is_in_group("Player") and enemiesleft:
		deadBody.visible = false
