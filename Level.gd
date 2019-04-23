extends Node


onready var HUD = $HUD
onready var player = $Player

var coinsCollected = 0
onready var coinsAtStart = get_tree().get_nodes_in_group('coin').size()

func player_died():
	HUD.show_msg("You died.")
	yield(HUD.get_node("msgTimer"), "timeout")
	get_tree().reload_current_scene()


func player_reached_goal():
	print('_on_Player_reached_goal()')
	HUD.show_msg("GOAL")
	yield(HUD.get_node("msgTimer"), "timeout")
	level_manager.onCurLevelComplete(coinsCollected, coinsAtStart)


func togglePause():
	print('toggling pause')
	if get_tree().paused:
		HUD.unpause()
		get_tree().paused = false
	else:
		HUD.pause()
		get_tree().paused = true


func quitToMainMenu():
	get_tree().change_scene("Menu.tscn")
	get_tree().paused = false


func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
        togglePause()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		togglePause()

func _ready():
	HUD.setCoinCount(0)
	HUD.show_msg(level_manager.getCurLevelName() + ":\nSTART!")
	yield(HUD.get_node("msgTimer"), "timeout")
	player.start_moving()


func onCoin(count):
	coinsCollected += count
	HUD.setCoinCount(coinsCollected)