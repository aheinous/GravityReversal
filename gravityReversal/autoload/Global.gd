extends Node


func _notification(what):

#	print('global._notification( ', what, ' )')


	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print('got NOTIFICATION_WM_QUIT_REQUEST or NOTIFICATION_WM_GO_BACK_REQUEST')
		fakeEscapePress()


var time = 0.0 setget , getTime

func getTime():
	return time

var _levelStartTime = 0


var randomPhases = {}

func getRandomPhase(n):
	if not n in randomPhases:
		randomPhases[n] = randf()
	return randomPhases[n]

func onLevelReady():
	_levelStartTime = getTime()
	randomPhases = {}

func getLevelTime():
	return getTime() - _levelStartTime


func _physics_process(delta):
	time += delta


func fakeEscapePress():
	print('fake escape press')
	var pressEvent = InputEventAction.new()
	pressEvent.set_action("ui_cancel")
	pressEvent.pressed = true
	Input.parse_input_event(pressEvent)

	var releaseEvent = InputEventAction.new()
	releaseEvent.set_action("ui_cancel")
	releaseEvent.pressed = false
	Input.parse_input_event(releaseEvent)

func getHUD():
	return $'/root/Level/HUD'

func getPlayer():
	return $'/root/Level/Player'
