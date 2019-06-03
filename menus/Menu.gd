extends Control



func _ready():
	var songScn = preload("res://songs/TitleSong.tscn")
	MusicPlayer.setSong(songScn)

func _on_NewGameButton_pressed():
	LevelTransitions.enterLevel(LevelInfoManager.levelInfoList[0].scenePath)


func _on_QuitButton_pressed():
	quit()


func quit():
	print("bye.")
	get_tree().quit()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		quit()


func _on_LevelSelectButton_pressed():
	get_tree().change_scene("menus/LevelSelectMenu.tscn")


func _on_OptionsButton_pressed():
#	get_tree().change_scene("menus/Options.tscn")
	var optionsScn = preload("res://menus/Options.tscn")
	self.add_child(optionsScn.instance())

