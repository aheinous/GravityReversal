extends Node


class LevelMetaData:
	var name
	var scenePath
	var maxCoinsCollected
	var coinsAvail

	func _init(name, path, maxCoinsCollected=null, coinsAvail=null):
		self.name = name
		self.scenePath = path
		self.maxCoinsCollected = maxCoinsCollected
		self.coinsAvail = coinsAvail


var levels = null
var highestLevelCompleted = null

var curLevelNum = null


func initDefaults():
	levels = [
		LevelMetaData.new('Straight Level', 'levels/straight.tscn'),
		LevelMetaData.new('Level No. 3', 'levels/level3.tscn'),
	]
	highestLevelCompleted = -1



func getHUD():
	return get_tree().get_current_scene().get_node('HUD')

#func getHUD():
#	return get_tree().get_current_scene().get_node('HUD')

func onCurLevelComplete(coinsCollected, coinsTotal):
	print('onCurLevelComplete. got ', coinsCollected, ' / ', coinsTotal, ' coins')

	# should only happen when running scenes as opposed to whole game
	if curLevelNum == null:
		get_tree().change_scene("menus/Menu.tscn")
		return

	# update num coins collected
	var oldMaxCoins = levels[curLevelNum].maxCoinsCollected
	if oldMaxCoins == null:
		oldMaxCoins = 0
	levels[curLevelNum].maxCoinsCollected = max(coinsCollected, oldMaxCoins)
	levels[curLevelNum].coinsAvail = coinsTotal

	# update highest level completed
	highestLevelCompleted = max(highestLevelCompleted, curLevelNum)

	# save game
	saveGame()

	# either load next level or inform user they beat the game
	curLevelNum += 1
	if curLevelNum >= levels.size():
		getHUD().show_msg("You Beat The Game!")
		yield(getHUD().get_node("msgTimer"), "timeout")
		curLevelNum = null
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

func clearSaveData():
	Directory.new().remove(SAVE_PATH)
	initDefaults()


func saveGame():
	print('saving game')

	var save = {}
	save['version'] = ProjectSettings.get_setting('application/config/version')
	save['highestLevelCompleted'] = highestLevelCompleted

	for metaData in levels:
		save[metaData.scenePath + ': maxCoinsCollected'] = metaData.maxCoinsCollected
		save[metaData.scenePath + ': coinsAvail'] = metaData.coinsAvail


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

	for metaData in levels:
		metaData.maxCoinsCollected = save[metaData.scenePath + ': maxCoinsCollected']
		metaData.coinsAvail = save[metaData.scenePath + ': coinsAvail']

func _ready():
	initDefaults()
	loadGame()
