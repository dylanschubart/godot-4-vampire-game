extends TextureRect

@export var dialogPath = ""
@export var textSpeed = 0.05
#@onready var player = get_tree().root.get_node("/root/World/Player")

var dialog
 
var phraseNum = 0
var finished = false
 
func _ready():
#	get_parent().hide()
	start()
	
func start():
	$Timer.wait_time = textSpeed
	phraseNum = 0
	get_parent().show()
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	$Indicator/AnimationPlayer.play("Indicator")
	
func _process(_delta):
#	$Indicator.visible = finished
	if Input.is_action_just_pressed("Interact"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
 
func getDialog() -> Array:
	var f = FileAccess.open(dialogPath,FileAccess.READ)
	assert(FileAccess.file_exists(dialogPath), "File path does not exist")
	
	var json_object = JSON.new()
	json_object.parse(f.get_as_text())
	var output = json_object.get_data()
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		get_parent().hide()
#		player.dialogueActive = false
		return
	
	finished = false
	
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var f = FileAccess.open(dialogPath,FileAccess.READ)
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		await get_tree().create_timer(textSpeed).timeout
		
	finished = true
	phraseNum += 1
	return