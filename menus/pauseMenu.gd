extends CanvasLayer


const confirmPkdScn = preload('res://menus/ConfirmDialog.tscn')


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		_on_continueButton_pressed()


func _on_continueButton_pressed():
	get_tree().get_current_scene().togglePause()


func onQuitConfirmed():
	LevelTransitions.quitLevel()
	get_tree().paused = false


func _on_quitButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Quit to main menu?",
				"Yes", self, "onQuitConfirmed",
				"No")

func _on_optionsButton_pressed():
	var optionsPkdScn = preload("res://menus/Options.tscn")
	self.add_child(optionsPkdScn.instance())


func _on_restartButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Restart level?",
				"Yes", self, "onRestartConfirmed",
				"No")

func onRestartConfirmed():
	LevelTransitions.restartAtBeginning()
	get_tree().paused = false



func _on_loadChkptButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Load last checkpoint?",
				"Yes", self, "onLoadChkptConfirmed",
				"No")


func onLoadChkptConfirmed():
	LevelTransitions.restartAtCheckpointOrBeginning()
	get_tree().paused = false

