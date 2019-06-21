extends CanvasLayer

onready var lvlCompleteLabel = $'Control/MarginContainer/MarginContainer/VBoxContainer/LevelCompleteLabel'

onready var nextButton = $'Control/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/Buttons/NextButton'


onready var runStats = $Control/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/thisRunStats
onready var overallStats = $Control/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/overallStats


func setup(coinsCollected, coinsAtStart, gems, noDeaths):
	var lvlInfo = LevelInfoManager.getCurLevelInfo()

	runStats.setupLabel("This Run", coinsCollected, coinsAtStart, gems, noDeaths)
	overallStats.setupLabel("Overall", lvlInfo.maxCoinsCollected, lvlInfo.coinsAvail, lvlInfo.gems, lvlInfo.noDeaths)


	if LevelInfoManager.getNextLevel() == null:
		lvlCompleteLabel.text = 'You Beat The Game!'
		nextButton.disabled = true


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
