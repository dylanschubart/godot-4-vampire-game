extends CanvasLayer

#hubSave
var hubPlayerPosition
var hubDaddyProgress
var hubOpenedDoors = []

#roomSaves
var roomPlayerPosition = []
var roomCompleted = []
var wentIntoLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func saveHub(player, daddyPath, door):
	hubPlayerPosition = player.global_position
	hubDaddyProgress = daddyPath.get_progress()
	hubOpenedDoors.clear()
	for item in door:
		if !item.get_node("InteractableZone/CollisionShape2D").is_disabled():
			hubOpenedDoors.append(item.get_node("InteractableZone").doorNumber)
			
	print('Saving hub')
	print('Player position: ' + str(hubPlayerPosition))
	print("Daddy's path progress: " + str(hubDaddyProgress))
	print('Opened doors: ' + str(hubOpenedDoors))
	
func loadHub(player, daddyPath, door):
	if hubPlayerPosition == null: return
		
	player.global_position = hubPlayerPosition
	daddyPath.set_progress(hubDaddyProgress)
	daddyPath.get_node('Daddy').reached_end = true
	
	for openedDoor in hubOpenedDoors:
		for item in door:
			if item.get_node("InteractableZone").doorNumber == openedDoor:
				item.get_node("InteractableZone/CollisionShape2D").set_disabled(false)
				item.get_node("DoorTexture/AnimationPlayer").play("Open")
				item.get_node("DoorTexture/AnimationPlayer").seek(1.0)
		
	print('Loading hub')
	print('Player position: ' + str(hubPlayerPosition))
	print("Daddy's path progress: " + str(hubDaddyProgress))
	print('Opened doors: ' + str(hubOpenedDoors))
		

func saveRoom(index, player, levelEntered):
	if roomPlayerPosition.size() > index:
		roomPlayerPosition[index] = player.global_position
	else: 
		roomPlayerPosition.append(player.global_position)
	wentIntoLevel = levelEntered
	
func loadRoom(index, player):
	if roomPlayerPosition.size() > index:
		player.global_position = roomPlayerPosition[index]
	player.returning = wentIntoLevel
		
func saveLevel(_index):
	pass

func loadLevel(_index):
	pass


