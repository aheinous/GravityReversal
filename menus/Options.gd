extends Control


func _on_ResetButton_pressed():
	level_manager.clearSaveData()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		goBack()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		goBack()

func goBack():
	get_tree().change_scene("menus/Menu.tscn")
