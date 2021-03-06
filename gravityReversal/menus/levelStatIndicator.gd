extends Control

onready var label = $MarginContainer/CenterContainer/VBoxContainer/Label
onready var button = $MarginContainer/CenterContainer/VBoxContainer/Button
onready var coinCnt = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/MenuCoinCount
onready var gemsIndicator = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/GemIndicator
onready var noDeathIndicator = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/NoDeathsIndicator


var levelPath = null


func setupLabel(txt, coinsCollected, coinsAvail, gems, noDeaths):
	label.visible = true
	button.visible = false
	label.text = txt
	coinCnt.setCoinCount(coinsCollected, coinsAvail)
	gemsIndicator.setGems(gems)
	noDeathIndicator.setNoDeaths(noDeaths)

func setupButton(levelInfo):
	label.visible = false
	button.visible = true
	button.text = levelInfo.name

	levelPath = levelInfo.scenePath

	button.disabled = not levelInfo.isAvailable()

	if levelInfo.completed:
		coinCnt.setCoinCount(levelInfo.maxCoinsCollected, levelInfo.coinsAvail)
		gemsIndicator.setGems(levelInfo.gems)
		noDeathIndicator.setNoDeaths(levelInfo.noDeaths)
	else:
		coinCnt.setBlank(true)
		gemsIndicator.setGems(null)
		noDeathIndicator.setBlank(true)



func _on_Button_pressed():
	LevelTransitions.enterLevel(levelPath)
