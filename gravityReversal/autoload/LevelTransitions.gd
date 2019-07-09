extends Node


var levelCompleteMenu = preload('res://menus/LevelCompleteMenu.tscn')


func enterLevel(scnPath):
	SceneLoader.loadScene(scnPath)
	LevelPersistent.onEnterLevel()

func restartAtBeginning():
	CheckpointSys.resetState()
	LevelPersistent.onEnterLevel()
	SceneLoader.reloadScene()

func restartAtCheckpointOrBeginning():

	if CheckpointSys.hasCheckpoint():
		SceneLoader.reloadScene()
	else:
		restartAtBeginning()

func quitLevel():
	CheckpointSys.onLevelExit()
	SceneLoader.loadScene('menus/Menu.tscn')

func completeLevel(coinsCollected, coinsAtStart, gems, noDeaths):
	LevelInfoManager.onLevelCompleted(getCurLevelPath(), coinsCollected, coinsAtStart, gems, noDeaths)
	SaveSys.saveGame()
	var levelCompleteMenuInstance = levelCompleteMenu.instance()
	get_tree().get_current_scene().add_child(levelCompleteMenuInstance)
	levelCompleteMenuInstance.setup(coinsCollected, coinsAtStart, gems, noDeaths)



func loadNextLevel():
	CheckpointSys.onLevelExit()
	enterLevel(LevelInfoManager.getNextLevel())

func getCurLevelPath():
	assert(get_tree().current_scene.filename.begins_with('res://'))
	return get_tree().current_scene.filename