extends CanvasLayer

@export var progress = 0
@export var maxprogress = 3

@onready var _progressLabel = $AmountProgress
@onready var _maxLabel = $AmountMax

# Called when the node enters the scene tree for the first time.
func _ready():
	_progressLabel.text = str(progress)
	_maxLabel.text = "/ " + str(maxprogress)

func sacrificed():
	progress += 1
	_progressLabel.text = str(progress)
	
	if progress == maxprogress:
		get_tree().current_scene.get_node("Altar").lastEnemyKilled()
