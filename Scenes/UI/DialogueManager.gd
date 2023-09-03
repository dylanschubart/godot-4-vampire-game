extends Node

func showDialogueBox(dialoguepath):
	var dialogueBox = get_tree().root.get_node("/root/World/DialogueBox/DialogueSprite")
	dialogueBox.dialogPath = dialoguepath
	dialogueBox.start()
