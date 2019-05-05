extends Control


const confirmScn = preload('res://menus/ConfirmDialog.tscn')

func _on_ResetButton_pressed():
	var confirm = confirmScn.instance()
	add_child(confirm)
	confirm.setup("Really reset save data?",
				"Yes", self, "onYesPressed",
				"No")


func onYesPressed():
	level_manager.clearSaveData()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		goBack()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		goBack()

func goBack():
	get_tree().change_scene("menus/Menu.tscn")
