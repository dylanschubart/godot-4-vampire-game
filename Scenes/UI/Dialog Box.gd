extends TextureRect

@export var dialogPath = ""
@export var textSpeed = 0.05
@onready var daddy_talking = get_tree().root.get_node("/root/World/Audio/daddy_talking")

var dialog
 
var phraseNum = 0
var finished = false
 
func _ready():
	get_parent().hide()

	
func start():
	Audio.get_node("daddy_talking").play()
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
		var daddy = get_node("/root/World/WalkingPath/WalkingFollowPath/Daddy")
		get_parent().hide()
		daddy.dialogueIsFinished = true
		return
	Audio.get_node("daddy_talking").play()
	finished = false
	
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		await get_tree().create_timer(textSpeed).timeout
		
	finished = true
	phraseNum += 1
	return
