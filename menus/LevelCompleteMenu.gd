extends CanvasLayer

onready var lvlCompleteLabel = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LevelCompleteLabel'
onready var nextButton = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/NextButton'

onready var runCoinCount = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/runCoinCount'
onready var runGems = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/runGems'
onready var overallCoinCount = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/overallCoinCount'
onready var overallGems = $'Control/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/overallGems'



func setup(coinsCollected, coinsAtStart, gems):
	var lvlInfo = LevelInfoManager.getCurLevelInfo()

	runCoinCount.setCoinCount(coinsCollected, coinsAtStart)
	runGems.setGems(gems)
	overallCoinCount.setCoinCount(lvlInfo.maxCoinsCollected, lvlInfo.coinsAvail)
	overallGems.setGems(lvlInfo.gems)

	if LevelInfoManager.getNextLevel() == null:
		lvlCompleteLabel.text = 'You Beat The Game!'
		nextButton.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# stop game from pausing
		get_tree().set_input_as_handled()


func _on_RestartButton_pressed():
	LevelTransitions.restartAtBeginning()


func _on_NextButton_pressed():
	LevelTransitions.loadNextLevel()


func _on_QuitButton_pressed():
	LevelTransitions.quitLevel()


func _on_LastCheckpointButton_pressed():
	LevelTransitions.restartAtCheckpointOrBeginning()
