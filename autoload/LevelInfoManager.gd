extends Node

class LevelInfo:
	var name
	var scenePath
	var maxCoinsCollected
	var coinsAvail
	var gems = null
	var noDeaths = false
	var completed = false
	var madeAvail = false

	func _init(name, path, maxCoinsCollected=null, coinsAvail=null):
		self.name = name
		self.scenePath = path
		self.maxCoinsCollected = maxCoinsCollected
		self.coinsAvail = coinsAvail

	func isAvailable():
		return LevelInfoManager.isLevelAvailable(scenePath)

var levelInfoList = null


func _ready():
	reset()

func reset():
  levelInfoList = [
		LevelInfo.new('Tutorial', 'res://levels/tutorial.tscn'),					# CoolOne
		LevelInfo.new("Baby's First Steps", 'res://levels/learnToFloat.tscn'),		# titleSongPlus
		LevelInfo.new("Young Padawan", 'res://levels/learnToStall.tscn'),			# ultimatum
		LevelInfo.new("On The Edge", 'res://levels/learnToPop.tscn'),				# CoolOne
		LevelInfo.new('Easy Street', 'res://levels/easyStreet.tscn'),				# letsRock
		LevelInfo.new('Deep Dive', 'res://levels/learnToDive.tscn'),				# titleSongPlus
		LevelInfo.new('Missile Command', 'res://levels/missileCmd.tscn'),			# CoolOne
		LevelInfo.new('Saw Hallway', 'res://levels/SawHallway.tscn'),				# let's rock
		LevelInfo.new('Floating Thru Space', 'res://levels/floatingThruSpace.tscn'),# ultimatum
		LevelInfo.new('Red Space', 'res://levels/redSpace.tscn'),					# CoolOne
	]


func getLevelInfo(scnPath):
	for levelInfo in levelInfoList:
		if levelInfo.scenePath == scnPath:
			return levelInfo
	assert(false)

func getCurLevelInfo():
	return getLevelInfo(LevelTransitions.getCurLevelPath())

func getCurLevelName():
	if LevelTransitions.getCurLevelPath() == null:
		return 'level name not found'
	return getLevelInfo(LevelTransitions.getCurLevelPath()).name


func onLevelCompleted(scnPath, coinsCollected, coinsAvail, gems, noDeaths):
	# update level info
	var levelInfo = getLevelInfo(scnPath)

	# if level never completed or that which is available differs (ie different version of level)
	if (levelInfo.maxCoinsCollected == null
			or levelInfo.coinsAvail != coinsAvail
			or levelInfo.gems.keys() != gems.keys()):
		levelInfo.coinsAvail = coinsAvail
		levelInfo.maxCoinsCollected = coinsCollected
		levelInfo.gems = gems
		levelInfo.noDeaths = noDeaths
	else:
		levelInfo.maxCoinsCollected = max(levelInfo.maxCoinsCollected, coinsCollected)
		for color in gems.keys():
			levelInfo.gems[color] = levelInfo.gems[color] or gems[color]
		levelInfo.noDeaths = levelInfo.noDeaths or noDeaths

	levelInfo.completed = true
	levelInfo.madeAvail = true


func getNextLevel(scnPath = null):
	if scnPath == null:
		scnPath = LevelTransitions.getCurLevelPath()
	for i in range(levelInfoList.size()):
		if levelInfoList[i].scenePath == scnPath:
			return levelInfoList[i+1].scenePath if i+1 < levelInfoList.size() else null
	assert(false)


func isLevelAvailable(scnPath):
	for i in range(levelInfoList.size()):
		if levelInfoList[i].scenePath == scnPath:
			return i==0 or levelInfoList[i-1].completed or levelInfoList[i].madeAvail
	assert(false)



func saveGame(saveData):
	for levelInfo in levelInfoList:
		saveData[levelInfo.scenePath + ': maxCoinsCollected'] = levelInfo.maxCoinsCollected
		saveData[levelInfo.scenePath + ': coinsAvail'] = levelInfo.coinsAvail
		saveData[levelInfo.scenePath + ': gems'] = levelInfo.gems
		saveData[levelInfo.scenePath + ': noDeaths'] = levelInfo.noDeaths
		saveData[levelInfo.scenePath + ': completed'] = levelInfo.completed
		saveData[levelInfo.scenePath + ': madeAvail'] = isLevelAvailable(levelInfo.scenePath)

func loadGame(saveData):
	for levelInfo in levelInfoList:
		levelInfo.maxCoinsCollected = saveData.get(levelInfo.scenePath + ': maxCoinsCollected')
		levelInfo.coinsAvail = saveData.get(levelInfo.scenePath + ': coinsAvail')
		levelInfo.gems = saveData.get(levelInfo.scenePath + ': gems')
		levelInfo.noDeaths = saveData.get(levelInfo.scenePath + ': noDeaths', false)
		levelInfo.completed = saveData.get(levelInfo.scenePath + ': completed', false)
		levelInfo.madeAvail = saveData.get(levelInfo.scenePath + ": madeAvail", false)