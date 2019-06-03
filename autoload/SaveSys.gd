extends Node

const SAVE_PATH = 'user://savefile'

func _ready():
	loadGame()

func saveGame():
	print('Saving game')

	var saveData = {}
	saveData['version'] = ProjectSettings.get_setting('application/config/version')
	saveData['saveFmtVersion'] = 1

	LevelInfoManager.saveGame(saveData)

	saveData['fxVolume'] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('fx'))
	saveData['musicVolume'] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('music'))

	var saveFile = File.new()
	saveFile.open(SAVE_PATH, File.WRITE)
	saveFile.store_line(to_json(saveData))
	saveFile.close()


func loadGame():
	var saveFile = File.new()
	if not saveFile.file_exists(SAVE_PATH):
		print('No save file found.')
		return
	print('Loading game.')
	saveFile.open(SAVE_PATH, File.READ)
	var saveData = parse_json(saveFile.get_as_text())
	print('save file game version: ', saveData['version'])
	print('save file format version: ', saveData.get('saveFmtVersion'))

	LevelInfoManager.loadGame(saveData)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('fx'), saveData['fxVolume'])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('music'), saveData['musicVolume'])
	saveFile.close()

func clearSaveData():
	Directory.new().remove(SAVE_PATH)
	LevelInfoManager.reset()
	saveGame()

