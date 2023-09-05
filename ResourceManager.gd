extends CanvasLayer

#hubSave
var hubPlayerPosition
var hubDaddyProgress
var hubOpenedDoors = []

#roomSaves
var roomPlayerPosition = []
var roomSacrificed = []
var roomHealth = []
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
		
	var daddyNode = get_node("/root/World/FlyingPath/FlyingFollowPath/Daddy")
		
	#player
	player.global_position = hubPlayerPosition
	#remove daddy from flight and add to walkpath
	daddyNode.get_parent().remove_child(daddyNode)
	daddyPath.add_child(daddyNode)
	daddyPath.set_progress(hubDaddyProgress)
	daddyNode.reached_end = true
	daddyNode.startAnimationEnded = true
	
	
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
	
	if roomSacrificed.size() > index:
		var sacrificedScore = get_tree().root.get_node("Room" + str(index + 1) + "/LevelSelect/Sacrificed/BestScore")
		sacrificedScore.text = str(roomSacrificed[index])
		
	if roomHealth.size() > index:
		var bloodScore = get_tree().root.get_node("Room" + str(index + 1) + "/LevelSelect/Blood/BestScore") 
		bloodScore.text = str(roomHealth[index])
		
		
func saveLevel(index, health, sacrificed):
	#save sacrificed amount
	if roomSacrificed.size() > index:
		if sacrificed > roomSacrificed[index]:
			roomSacrificed[index] = sacrificed
	else:
		roomSacrificed.append(sacrificed)
	#save health amount
	if roomHealth.size() > index:
		if health > roomHealth[index]:
			roomHealth[index] = health
	else:
		roomHealth.append(health)
		
	print('Saving level')
	print('Sacrificed enemies: ' + str(roomSacrificed[index]))
	print("Health: " + str(roomHealth[index]))
	
func getLevelInfo(index):
	if roomSacrificed.size() > index and roomHealth.size() > index:
		return int(roomSacrificed[index]) + int(roomHealth[index])
	return 0

func wipe():
	#hubSave
	hubPlayerPosition = null
	hubDaddyProgress = null
	hubOpenedDoors = []

#roomSaves
	roomPlayerPosition = []
	roomSacrificed = []
	roomHealth = []
	wentIntoLevel = null

