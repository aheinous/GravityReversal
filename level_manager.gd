extends Node


class LevelMetaData:
	var name
	var scenePath
	var maxCoinsCollected
	var coinsAvail
	var gems = null
	var completed = false
	var madeAvail = false

	func _init(name, path, maxCoinsCollected=null, coinsAvail=null):
		self.name = name
		self.scenePath = path
		self.maxCoinsCollected = maxCoinsCollected
		self.coinsAvail = coinsAvail


var levels = null
var curLevelNum = null


func getHUD():
	return get_tree().get_current_scene().get_node('HUD')


func onCurLevelComplete(coinsCollected, coinsTotal, gems):
	print('onCurLevelComplete. got ', coinsCollected, ' / ', coinsTotal, ' coins')
	print(gems)

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

	# update gems
	if levels[curLevelNum].gems == null:
		levels[curLevelNum].gems = gems
	else:
		var newGems = {}
		for color in gems.keys():
			newGems[color] = gems[color] or levels[curLevelNum].gems[color]
		levels[curLevelNum].gems = newGems

	# update highest level completed
	levels[curLevelNum].completed = true

	# save game
	saveGame()

	# either load next level or inform user they beat the game
	curLevelNum += 1
	if curLevelNum >= levels.size():
		getHUD().showMsg("You Beat The Game!")
		yield(getHUD().get_node("msgTimer"), "timeout")
		curLevelNum = null
		get_tree().change_scene("menus/Menu.tscn")
		return
	else:
		loadLevelNum(curLevelNum)


func isAvail(metaData):
	var num = getLevelNum(metaData)
	return num == 0 or levels[num-1].completed or levels[num].madeAvail

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

	SceneLoader.loadScene(levels[n].scenePath)


const SAVE_PATH = 'user://savefile'


func initDefaults():
	# data to be loaded when no save file is present
	levels = [
		LevelMetaData.new('Tutorial', 'levels/tutorial.tscn'),
		LevelMetaData.new('Easy Street', 'levels/easyStreet.tscn'),
		LevelMetaData.new('Missile Command', 'levels/missileCmd.tscn'),
		LevelMetaData.new('Saw Hallway', 'levels/SawHallway.tscn'),
		LevelMetaData.new('Floating Thru Space', 'levels/floatingThruSpace.tscn'),
		LevelMetaData.new('Red Space', 'levels/redSpace.tscn'),


	]


func clearSaveData():
	Directory.new().remove(SAVE_PATH)
	initDefaults()


func saveGame():
	print('saving game')

	var save = {}
	save['version'] = ProjectSettings.get_setting('application/config/version')

	for metaData in levels:
		save[metaData.scenePath + ': maxCoinsCollected'] = metaData.maxCoinsCollected
		save[metaData.scenePath + ': coinsAvail'] = metaData.coinsAvail
		save[metaData.scenePath + ': gems'] = metaData.gems
		save[metaData.scenePath + ': completed'] = metaData.completed
		save[metaData.scenePath + ': madeAvail'] = isAvail(metaData)





	save['fxVolume'] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('fx'))
	save['musicVolume'] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('music'))


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

	for metaData in levels:
		metaData.maxCoinsCollected = save.get(metaData.scenePath + ': maxCoinsCollected')
		metaData.coinsAvail = save.get(metaData.scenePath + ': coinsAvail')
		metaData.gems = save.get(metaData.scenePath + ': gems', {})
		metaData.completed = save.get(metaData.scenePath + ': completed', false)
		metaData.madeAvail = save.get(metaData.scenePath + ": madeAvail", false)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('fx'), save['fxVolume'])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('music'), save['musicVolume'])


func _ready():
	initDefaults()
	loadGame()
