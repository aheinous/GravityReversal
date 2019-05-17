extends Node


export (String, FILE) var songPath

onready var songScn = load(songPath)

onready var HUD = $HUD
onready var player = $Player

var coinsCollected = 0
onready var coinsAtStart = get_tree().get_nodes_in_group('coin').size()

onready var gems = initGems()


func initGems():
	# WARNING: only valid before any gems are collected.
	var gems = {}
	for gem in get_tree().get_nodes_in_group('gem'):
		gems[gem.color] = false
	return gems

func player_died():
	var msgs = ['You died.\n Try not doing that.',
					'Oh look, you\'re dead.',
					'Oh look, you\'re dead now.',
					'Try not to die.',
					'You should try not dying next time.',
					'You\'re doing it wrong.\nTry to *avoid* death.',
					'That\'s the end of you.',
					'No more you.'


					]




	var msg = msgs[randi() % msgs.size()]
#	HUD.show_msg("You died.")
	HUD.show_msg(msg)
	yield(HUD.get_node("msgTimer"), "timeout")
	get_tree().reload_current_scene()


func player_reached_goal():
	print('_on_Player_reached_goal()')
	HUD.show_msg("Level Complete")
	yield(HUD.get_node("msgTimer"), "timeout")
	level_manager.onCurLevelComplete(coinsCollected, coinsAtStart, gems)




func quitToMainMenu():
	get_tree().change_scene("menus/Menu.tscn")
	get_tree().paused = false



func _ready():

	MusicPlayer.setSong(self.songScn)
	HUD.setCoinCount(0)
	HUD.setGems(gems)
	HUD.show_msg(level_manager.getCurLevelName() + ":\nSTART!")
	yield(HUD.get_node("msgTimer"), "timeout")
	player.start_moving()


func onCoin(count):
	coinsCollected += count
	HUD.setCoinCount(coinsCollected)

func onGem(color):
	print("A ", color, " gem was collected.")
	gems[color] = true
	HUD.setGems(gems)