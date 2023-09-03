extends Node



func showDialogueBox(dialoguepath):
	var dialogueBox = get_tree().root.get_node("/root/World/UserInterface/DialogueBox/DialogueSprite")
	dialogueBox.dialogPath = dialoguepath
	dialogueBox.start()
