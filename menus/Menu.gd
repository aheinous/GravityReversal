extends Control



func _ready():
	var songScn = preload("res://songs/TitleSong.tscn")
	MusicPlayer.setSong(songScn)

func _on_NewGameButton_pressed():
#	get_tree().change_scene("level1.tscn")
	level_manager.loadLevelNum(0)


func _on_QuitButton_pressed():
	quit()


func quit():
	print("bye.")
	get_tree().quit()


#
#func _input(event):
#	print('Menu _input: ', event, event.as_text(), event.is_action_type())

func _unhandled_input(event):
#	print('Menu _unhandled_input: ', event, event.as_text(), event.is_action_type(), event.is_action("ui_cancel"), event.is_pressed())
	if event.is_action_pressed("ui_cancel"):
		quit()




#func _process(delta):
#	if Input.is_action_just_pressed("ui_cancel"):
#		print('a')
#		quit()



#func _notification(what):
##	print('what: ', what)
#	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
#		print('b')
#		quit()

func _on_LevelSelectButton_pressed():
	get_tree().change_scene("menus/LevelSelectMenu.tscn")


func _on_OptionsButton_pressed():
#	get_tree().change_scene("menus/Options.tscn")
	var optionsScn = preload("res://menus/Options.tscn")
	self.add_child(optionsScn.instance())


func _on_StartMenu_gui_input(event):
	pass # Replace with function body.
	print('gui input event: ', event)
