extends Control

#onready var buttonContainer = $ScrollContainer/CenterContainer/MarginContainer/LevelGrid
#onready var buttonContainer = $ScrollContainer/MarginContainer/LevelGrid
onready var buttonContainer = $ScrollContainer/CenterContainer/MarginContainer/VBoxContainer/LevelGrid


func _ready():
	for child in buttonContainer.get_children():
		buttonContainer.remove_child(child)
		child.queue_free()

	var buttonScene = load("res://menus/LevelButton.tscn")
	var coinCountScene = load('res://menus/MenuCoinCount.tscn')
	var gemIndicatorScene = load('res://menus/GemIndicator.tscn')

	for levelInfo in LevelInfoManager.levelInfoList:
		var button = buttonScene.instance()
		button.set_name(levelInfo.name + '_button')
		button.setup(levelInfo)
		buttonContainer.add_child(button)

		var coinCnt = coinCountScene.instance()
		var gemsIndicator = gemIndicatorScene.instance()

		buttonContainer.add_child(coinCnt)
		buttonContainer.add_child(gemsIndicator)

		gemsIndicator.setGems(levelInfo.gems)

		if levelInfo.maxCoinsCollected == null:
			coinCnt.setBlank(true)
		else:
			coinCnt.setCoinCount(levelInfo.maxCoinsCollected, levelInfo.coinsAvail)



func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		goBack()



func goBack():
	get_tree().change_scene("menus/Menu.tscn")