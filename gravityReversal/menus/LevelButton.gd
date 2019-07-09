extends Button

var levelInfo

func setup(levelInfo):
	self.levelInfo = levelInfo
	self.text = levelInfo.name
	self.disabled = not LevelInfoManager.isLevelAvailable(levelInfo.scenePath)


func _on_LevelButton_pressed():
	LevelTransitions.enterLevel(levelInfo.scenePath)
