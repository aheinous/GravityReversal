extends Node

func _ready():
	pass


func _notification(what):

#	print('global._notification( ', what, ' )')


	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print('got NOTIFICATION_WM_QUIT_REQUEST or NOTIFICATION_WM_GO_BACK_REQUEST')
		fakeEscapePress()




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

