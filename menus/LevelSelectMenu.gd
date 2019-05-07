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
	var levels = level_manager.levels

	for n in range(levels.size()):
		var metaData = levels[n]
		var button = buttonScene.instance()
		button.set_name(metaData.name + '_button')
		button.setup(metaData)
		buttonContainer.add_child(button)

		var coinCnt = coinCountScene.instance()
		var gemsIndicator = gemIndicatorScene.instance()

		buttonContainer.add_child(coinCnt)
		buttonContainer.add_child(gemsIndicator)

		gemsIndicator.setGems(metaData.gems)

		if metaData.maxCoinsCollected == null:
			coinCnt.setBlank(true)
		else:
			coinCnt.setCoinCount(metaData.maxCoinsCollected, metaData.coinsAvail)



func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		goBack()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		goBack()

func goBack():
	get_tree().change_scene("menus/Menu.tscn")