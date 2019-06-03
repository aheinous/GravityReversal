extends Node

class LevelInfo:
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


var levelInfoList = null


func _ready():
	reset()

func reset():
  levelInfoList = [
		LevelInfo.new('Tutorial', 'levels/tutorial.tscn'),
		LevelInfo.new("Baby's First Steps", 'levels/learnToFloat.tscn'),
		LevelInfo.new("Young Padawan", 'levels/learnToStall.tscn'),
		LevelInfo.new('Easy Street', 'levels/easyStreet.tscn'),
		LevelInfo.new('Missile Command', 'levels/missileCmd.tscn'),
		LevelInfo.new('Saw Hallway', 'levels/SawHallway.tscn'),
		LevelInfo.new('Floating Thru Space', 'levels/floatingThruSpace.tscn'),
		LevelInfo.new('Red Space', 'levels/redSpace.tscn'),
	]


func getLevelInfo(scnPath):
	for levelInfo in levelInfoList:
		if levelInfo.scenePath == scnPath:
			return levelInfo
	assert(false)


func getCurLevelName():
	if LevelTransitions.curLevelPath == null:
		return 'level name not found'
	return getLevelInfo(LevelTransitions.curLevelPath).name


func onLevelCompleted(scnPath, coinsCollected, coinsAvail, gems):
	# update level info
	var levelInfo = getLevelInfo(scnPath)

	# if level never completed or that which is available differs (ie different version of level)
	if (levelInfo.maxCoinsCollected == null
			or levelInfo.coinsAvail != coinsAvail
			or levelInfo.gems.keys() != gems.keys()):
		levelInfo.coinsAvail = coinsAvail
		levelInfo.maxCoinsCollected = coinsCollected
		levelInfo.gems = gems
	else:
		levelInfo.maxCoinsCollected = max(levelInfo.maxCoinsCollected, coinsCollected)
		for color in gems.keys():
			levelInfo.gems[color] = levelInfo.gems[color] or gems[color]

	levelInfo.completed = true
	assert(levelInfo.madeAvail)


func getNextLevel(scnPath):
	for i in range(levelInfoList.size()):
		if levelInfoList[i].scenePath == scnPath:
			return levelInfoList[i+1].scenePath if i+1 < levelInfoList.size() else null
	assert(false)


func isLevelAvailable(scnPath):
	for i in range(levelInfoList.size()):
		if levelInfoList[i].scenePath == scnPath:
			return i==0 or levelInfoList[i-0].completed or levelInfoList[i].madeAvail
	assert(false)



func saveGame(saveData):
	for levelInfo in levelInfoList:
		saveData[levelInfo.scenePath + ': maxCoinsCollected'] = levelInfo.maxCoinsCollected
		saveData[levelInfo.scenePath + ': coinsAvail'] = levelInfo.coinsAvail
		saveData[levelInfo.scenePath + ': gems'] = levelInfo.gems
		saveData[levelInfo.scenePath + ': completed'] = levelInfo.completed
		saveData[levelInfo.scenePath + ': madeAvail'] = isLevelAvailable(levelInfo.scenePath)

func loadGame(saveData):
	for levelInfo in levelInfoList:
		levelInfo.maxCoinsCollected = saveData.get(levelInfo.scenePath + ': maxCoinsCollected')
		levelInfo.coinsAvail = saveData.get(levelInfo.scenePath + ': coinsAvail')
		levelInfo.gems = saveData.get(levelInfo.scenePath + ': gems')
		levelInfo.completed = saveData.get(levelInfo.scenePath + ': completed', false)
		levelInfo.madeAvail = saveData.get(levelInfo.scenePath + ": madeAvail", false)