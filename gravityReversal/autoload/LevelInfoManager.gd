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
		LevelInfo.new('Intro', 'res://levels/tutorial.tscn'),					# CoolOne
		LevelInfo.new("Baby's First Steps", 'res://levels/learnToFloat.tscn'),		# titleSongPlus
		LevelInfo.new("Young Padawan", 'res://levels/learnToStall.tscn'),			# ultimatum
		LevelInfo.new("On The Edge", 'res://levels/learnToPop.tscn'),				# CoolOne
		LevelInfo.new('Easy Street', 'res://levels/easyStreet.tscn'),				# letsRock
		LevelInfo.new('Deep Dive', 'res://levels/learnToDive.tscn'),				# titleSongPlus
		LevelInfo.new('Missile Command', 'res://levels/missileCmd.tscn'),			# CoolOne
		LevelInfo.new('Saw Hallway', 'res://levels/SawHallway.tscn'),				# let's rock
		LevelInfo.new('Floating Thru Space', 'res://levels/floatingThruSpace.tscn'),# ultimatum
		LevelInfo.new('Red Space', 'res://levels/redSpace.tscn'),					# CoolOne
		LevelInfo.new('Plan 9', 'res://levels/plan9.tscn'),				# let's rock
	]


func getLevelInfo(scnPath):
	for levelInfo in levelInfoList:
		if levelInfo.scenePath == scnPath:
			return levelInfo
	return null


func getCurLevelInfo():
	return getLevelInfo(LevelTransitions.getCurLevelPath())

func getCurLevelName():
	var info = getLevelInfo(LevelTransitions.getCurLevelPath())
	return 'level name not found' if info==null else info.name



static func keysEqual(dictA, dictB):
	return dictA.has_all(dictB.keys()) and dictA.size() == dictB.size()


func onLevelCompleted(scnPath, coinsCollected, coinsAvail, gems, noDeaths):
	print('Level Completed: ', scnPath)

	# update level info
	var levelInfo = getLevelInfo(scnPath)

	print('\told level info: ', levelInfo.maxCoinsCollected, '/', levelInfo.coinsAvail, ' ', levelInfo.gems, 'noDeaths: ', levelInfo.noDeaths)
	print('\tthis run info:  ', coinsCollected, '/', coinsAvail, ' ', gems, 'noDeaths: ', noDeaths)

	# if level never completed or that which is available differs (ie different version of level)

#	print(levelInfo.maxCoinsCollected == null)
#	print(levelInfo.coinsAvail != coinsAvail)
#	print(levelInfo.gems.keys() != gems.keys())
#	print(!keysEqual(levelInfo.gems, gems))



	if (levelInfo.maxCoinsCollected == null
			or levelInfo.coinsAvail != coinsAvail
			or !keysEqual(levelInfo.gems, gems)):
		print('first completion or level changed since last completion')
		levelInfo.coinsAvail = coinsAvail
		levelInfo.maxCoinsCollected = coinsCollected
		levelInfo.gems = gems
		levelInfo.noDeaths = noDeaths
	else:
		print('not first completion')
		levelInfo.maxCoinsCollected = max(levelInfo.maxCoinsCollected, coinsCollected)
		for color in gems.keys():
			levelInfo.gems[color] = levelInfo.gems[color] or gems[color]
		levelInfo.noDeaths = levelInfo.noDeaths or noDeaths

	levelInfo.completed = true
	levelInfo.madeAvail = true

	print('\tnew level info: ', levelInfo.maxCoinsCollected, '/', levelInfo.coinsAvail, ' ', levelInfo.gems, 'noDeaths: ', levelInfo.noDeaths)


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