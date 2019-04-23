extends Control



func _on_NewGameButton_pressed():
#	get_tree().change_scene("level1.tscn")
	level_manager.loadLevelNum(0)


func _on_QuitButton_pressed():
	quit()


func quit():
	print("bye.")
	get_tree().quit()



func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		quit()



func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		quit()

func _on_LevelSelectButton_pressed():
	get_tree().change_scene("menus/LevelSelectMenu.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("menus/Options.tscn")
