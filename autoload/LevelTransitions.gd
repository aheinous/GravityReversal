extends Node


var curLevelPath = null setget , getCurLevelPath

var levelCompleteMenu = preload('res://menus/LevelCompleteMenu.tscn')


func enterLevel(scnPath):
	curLevelPath = scnPath
	SceneLoader.loadScene(scnPath)

func restartAtBeginning():
	CheckpointSys.onRestartAtBeginning()
	SceneLoader.reloadScene()

func restartAtCheckpointOrBeginning():
	CheckpointSys.onRestartAtCheckpointOrBeginning()
	SceneLoader.reloadScene()

func quitLevel():
	CheckpointSys.onLevelExit()
	curLevelPath = null
	SceneLoader.loadScene('menus/Menu.tscn')

func completeLevel(coinsCollected, coinsAtStart, gems):
#	CheckpointSys.onLevelExit()
	if curLevelPath == null: # scene loaded directly
		CheckpointSys.onLevelExit()
		SceneLoader.loadScene('menus/Menu.tscn')
		return

	LevelInfoManager.onLevelCompleted(curLevelPath, coinsCollected, coinsAtStart, gems)
	SaveSys.saveGame()
	var levelCompleteMenuInstance = levelCompleteMenu.instance()
	get_tree().get_current_scene().add_child(levelCompleteMenuInstance)
	levelCompleteMenuInstance.setup(coinsCollected, coinsAtStart, gems)



func loadNextLevel():
	CheckpointSys.onLevelExit()
	enterLevel(LevelInfoManager.getNextLevel(curLevelPath))

func getCurLevelPath():
	return curLevelPath