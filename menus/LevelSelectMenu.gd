extends Control

onready var buttonContainer = $ScrollContainer/CenterContainer/MarginContainer/VBoxContainer

func _ready():
	for child in buttonContainer.get_children():
		buttonContainer.remove_child(child)
		child.queue_free()

	var buttonScene = load("res://menus/LevelButton.tscn")
	var levels = level_manager.levels

	for n in range(levels.size()):
		var metaData = levels[n]
		var button = buttonScene.instance()
		button.set_name(metaData.name + '_button')
		button.setup(metaData)
		buttonContainer.add_child(button)
