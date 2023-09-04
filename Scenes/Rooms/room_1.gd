extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.get_node("BGHub").play()
	Audio.get_node("BGTitleScreen").stop()
	Audio.get_node("BGLevel").stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
