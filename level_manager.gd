extends Node


class LevelMetaData:
	var name
	var scenePath

	func _init(name, path):
		self.name = name
		self.scenePath = path


var levels = [
	LevelMetaData.new('Straight Level', 'levels/straight.tscn'),
	LevelMetaData.new('Level No. 3', 'levels/level3.tscn'),
]

var highestLevelCompleted = -1

var curLevelNum = null

#var HUD = null

func getHUD():
	return get_tree().get_current_scene().get_node('HUD')

#func getHUD():
#	return get_tree().get_current_scene().get_node('HUD')

func onCurLevelComplete(coinsCollected, coinsTotal):
	print('onCurLevelComplete. got ', coinsCollected, ' / ', coinsTotal, ' coins')
	if curLevelNum == null:
		get_tree().change_scene("menus/Menu.tscn")
		return

	highestLevelCompleted = max(highestLevelCompleted, curLevelNum)
	saveGame()
	curLevelNum += 1
	if curLevelNum >= levels.size():
		getHUD().show_msg("You Beat The Game!")
		yield(getHUD().get_node("msgTimer"), "timeout")


		curLevelNum = null
#		HUD = null
		get_tree().change_scene("menus/Menu.tscn")
		return
	else:
		loadLevelNum(curLevelNum)


func isAvail(metaData):
	return getLevelNum(metaData) <= highestLevelCompleted+1

func getCurLevelName():
	if curLevelNum == null:
		return 'Level Name Not Found'
	return levels[curLevelNum].name

func getLevelNum(metaData):
	for n in range(levels.size()):
		if levels[n] == metaData:
			return n
	assert(false)

func loadLevel(metaData):
	loadLevelNum(getLevelNum(metaData))

func loadLevelNum(n):

	print('loading level: ', n)
	curLevelNum = n

	get_tree().change_scene( levels[n].scenePath )
	var curScene = get_tree().get_current_scene()


const SAVE_PATH = 'user://savefile'

func saveGame():
	print('saving game')

	var save = {}
	save['version'] = ProjectSettings.get_setting('application/config/version')
	save['highestLevelCompleted'] = highestLevelCompleted

	var saveFile = File.new()
	saveFile.open(SAVE_PATH, File.WRITE)
	saveFile.store_line(to_json(save))
	saveFile.close()



func loadGame():
	var saveFile = File.new()
	if not saveFile.file_exists(SAVE_PATH):
		print('no save found.')
		return
	saveFile.open(SAVE_PATH, File.READ)
	var save = parse_json(saveFile.get_as_text())
	print('save file version: ', save['version'])
	highestLevelCompleted = save['highestLevelCompleted']


func _ready():
	loadGame()
