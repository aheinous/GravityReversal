extends Node


export (String, FILE) var songPath

onready var songScn = load(songPath)

onready var HUD = $HUD
onready var player = $Player

var coinsCollected = 0
onready var coinsAtStart = get_tree().get_nodes_in_group('coin').size()

onready var gems = initGems()

const pauseMenuPkdScn = preload('res://menus/pauseMenu.tscn')
var pauseMenu = null


func initGems():
	# WARNING: only valid before any gems are collected.
	var gems = {}
	for gem in get_tree().get_nodes_in_group('gem'):
		gems[gem.color] = false
	return gems

func playerDied():
	var msgs = ['You died.\n Try not doing that.',
					'Oh look, you\'re dead.',
					'Oh look, you\'re dead now.',
					'Try not to die.',
					'You should try not dying next time.',
					'You\'re doing it wrong.\nTry to *avoid* death.',
					'That\'s the end of you.',
					'No more you.']
	HUD.showMsg(msgs[randi() % msgs.size()])
	# TODO msg already showing??
	yield(HUD.get_node("msgTimer"), "timeout")
	HUD.showMsg('Press anywhere to continue')
	player.enableRestart()




func playerReachedGoal():
	print('_on_playerReachedGoal()')
#	HUD.showMsg("Level Complete")
#	yield(HUD.get_node("msgTimer"), "timeout")
	LevelTransitions.completeLevel(coinsCollected, coinsAtStart, gems)


func _ready():
	print('player pos: ', player.position)
	MusicPlayer.setSong(self.songScn)
	HUD.setCoinCount(0)
	HUD.setGems(gems)
	CheckpointSys.loadCheckpointData()



	HUD.showMsg(LevelInfoManager.getCurLevelName() + ":\nSTART!")

	yield(HUD.get_node("msgTimer"), "timeout")
	player.startMoving()
	print('player pos: ', player.position)


func onCoin(count):
	coinsCollected += count
	HUD.setCoinCount(coinsCollected)

func onGem(color):
	print("A ", color, " gem was collected.")
	gems[color] = true
	HUD.setGems(gems)

func togglePause():
	print('toggling pause')
	if get_tree().paused:
#		msgLabel.show()
#		pauseScreen.hide()
		pauseMenu.queue_free()
		pauseMenu = null
		get_tree().paused = false
	else:
#		msgLabel.hide()
#		pauseScreen.show()
		pauseMenu = pauseMenuPkdScn.instance()
		self.add_child(pauseMenu)
		get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		togglePause()
