extends Control

onready var levelListContainer = $ScrollContainer/MarginContainer/VBoxContainer/LevelList

func _ready():
	var levelStatScene = preload('res://menus/levelStatIndicator.tscn')
	for child in levelListContainer.get_children():
		levelListContainer.remove_child(child)
		child.queue_free()

	for levelInfo in LevelInfoManager.levelInfoList:
		var levelStats = levelStatScene.instance()
		levelListContainer.add_child(levelStats)
		levelStats.set_name(levelInfo.name + '_levelStats')
		levelStats.setupButton(levelInfo)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		goBack()



func goBack():
	get_tree().change_scene("menus/Menu.tscn")