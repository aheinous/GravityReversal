extends Button

var levelMetaData

func setup(levelMetaData):
	self.levelMetaData = levelMetaData
	self.text = levelMetaData.name
	self.disabled = not level_manager.isAvail(levelMetaData)


func _on_LevelButton_pressed():
	level_manager.loadLevel(levelMetaData)
