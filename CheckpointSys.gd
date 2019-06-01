extends Node


class ReplayableEvent:
	var nodePath
	var funcName
	var args

	func _init(obj, funcName, args):
		self.nodePath = obj.get_path()
		self.funcName = funcName
		self.args = args

	func play(ctx):
		var obj = ctx.get_node(self.nodePath)
		obj.callv(self.funcName, self.args)


var curEvents = []

var chkpt_pos = null
var chkpt_nodePath = null
var chkpt_events = null


func resetState():
	chkpt_pos = null
	chkpt_nodePath = null
	chkpt_events = null
	curEvents = []


func getHUD():
	return $'/root/Level/HUD'

func getPlayer():
	return $'/root/Level/Player'


func recordEvent(obj, funcName, args=[]):
	var event = ReplayableEvent.new(obj, funcName, args)
	curEvents.push_back(event)
	event.play(self)

func restartLevelOrCheckpoint():
#	print('restartLevelOrCheckpoint()')
	get_tree().reload_current_scene()

func restartAtBeginning():
	resetState()
	get_tree().reload_current_scene()


func loadCheckpointData():
#	print('loadCheckpoint()')
	if chkpt_pos == null:
		print('No checkpoint, restart at beginning')
		resetState()
		return
#	print('player pos: %s --> %s' % [getPlayer().position, chkpt_pos])
	getPlayer().position = chkpt_pos
	curEvents = chkpt_events.duplicate()
	for event in curEvents:
		event.play(self)


func playerReachedCheckpoint(pos, nodePath):
#	print('playerReachedCheckpoint(%s, %s)' % [pos, nodePath])
	if chkpt_nodePath == nodePath:
		return
	chkpt_pos = pos
	chkpt_nodePath = nodePath
	chkpt_events = curEvents.duplicate()
	getHUD().showMsg("Checkpoint", 0.5)
