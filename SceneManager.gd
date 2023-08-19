extends CanvasLayer

var currentScene = null
var sceneChange = false
var sceneChangeLimit = 180
var sceneChangeDelta = 0
var nextScene

const scenes = [("res://world.tscn")
,("res://Scenes/Rooms/room_1.tscn")]
var levels = [("res://world.tscn")
,"res://Scenes/Levels/level_1.tscn"]

func changeSceneWithTransition(scenePath):	
	sceneChange = true
	nextScene = scenePath

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sceneChange:
		sceneChangeDelta += 1
	
	if sceneChangeDelta >= sceneChangeLimit:
		goto_scene(nextScene)
		sceneChange = false
		sceneChangeDelta = 0
	
func goto_scene(path):
# This function will usually be called from a signal callback,
# or some other function in the current scene.
# Deleting the current scene at this point is
# a bad idea, because it may still be executing code.
# This will result in a crash or unexpected behavior.

# The solution is to defer the load to a later time, when
# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	currentScene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	currentScene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(currentScene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = currentScene

func saveCurrentSceneToLevels():
	levels[0] = get_tree().current_scene.scene_file_path