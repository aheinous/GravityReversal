extends Node


var levelCompleteMenu = preload('res://menus/LevelCompleteMenu.tscn')


func enterLevel(scnPath):
	SceneLoader.loadScene(scnPath)

func restartAtBeginning():
	CheckpointSys.onRestartAtBeginning()
	SceneLoader.reloadScene()

func restartAtCheckpointOrBeginning():
	CheckpointSys.onRestartAtCheckpointOrBeginning()
	SceneLoader.reloadScene()

func quitLevel():
	CheckpointSys.onLevelExit()
	SceneLoader.loadScene('menus/Menu.tscn')

func completeLevel(coinsCollected, coinsAtStart, gems):
	LevelInfoManager.onLevelCompleted(getCurLevelPath(), coinsCollected, coinsAtStart, gems)
	SaveSys.saveGame()
	var levelCompleteMenuInstance = levelCompleteMenu.instance()
	get_tree().get_current_scene().add_child(levelCompleteMenuInstance)
	levelCompleteMenuInstance.setup(coinsCollected, coinsAtStart, gems)



func loadNextLevel():
	CheckpointSys.onLevelExit()
	enterLevel(LevelInfoManager.getNextLevel())

func getCurLevelPath():
	assert(get_tree().current_scene.filename.begins_with('res://levels/'))
	return get_tree().current_scene.filename