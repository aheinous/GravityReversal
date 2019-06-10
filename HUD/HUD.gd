extends CanvasLayer

onready var pauseScreen = $pauseScreen
onready var msgLabel = $msgLabel
onready var msgTimer = $msgTimer
onready var coinCntLbl = $CoinCounter/Panel/HBoxContainer/Number
onready var gemIndicator = $MarginContainer/GemIndicator

const confirmPkdScn = preload('res://menus/ConfirmDialog.tscn')



func togglePause():
	print('toggling pause')
	if get_tree().paused:
		msgLabel.show()
		pauseScreen.hide()
		get_tree().paused = false
	else:
		msgLabel.hide()
		pauseScreen.show()
		get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		togglePause()



func setCoinCount(cnt):
	print('setCoinCount(', cnt, ')')
	coinCntLbl.text = str(cnt)

func _ready():
	clearMsg()
	msgLabel.show()
	pauseScreen.hide()


func pause():
	msgLabel.hide()
	pauseScreen.show()


func unpause():
	msgLabel.show()
	pauseScreen.hide()


var msgQueue = []
var msgTimeoutQueue = []
var curMsgFinishTime = 0

func clearMsg():
	msgLabel.text = ''
	curMsgFinishTime = 0

func showMsg(txt, timeout=2):
	msgQueue.push_front(txt)
	msgTimeoutQueue.push_front(timeout)
	msgTimer.stop()
	msgProcess()


func _on_msgTimer_timeout():
	msgProcess()

func msgProcess():
	var timeUntilCurMsgDone = curMsgFinishTime - Global.getTime()
	if timeUntilCurMsgDone > 0:
		msgTimer.start(timeUntilCurMsgDone)
		return

	clearMsg()

	if msgQueue.size() > 0:
		var curMsg = msgQueue.pop_back()
		var curTimeout = msgTimeoutQueue.pop_back()
		msgLabel.text = curMsg
		curMsgFinishTime = curTimeout + Global.getTime()
		msgTimer.start(curTimeout)

func _on_continueButton_pressed():
	togglePause()


func onQuitConfirmed():
	LevelTransitions.quitLevel()
	get_tree().paused = false


func _on_quitButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Quit to main menu?",
				"Yes", self, "onQuitConfirmed",
				"No")

func _on_optionsButton_pressed():
	var optionsPkdScn = preload("res://menus/Options.tscn")
	self.add_child(optionsPkdScn.instance())


func setGems(gems):
	print('HUD.setGems(',gems, ')')
	gemIndicator.setGems(gems)
	if gems.size() == 0:
		gemIndicator.visible = false

func _on_restartButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Restart level?",
				"Yes", self, "onRestartConfirmed",
				"No")

func onRestartConfirmed():
	LevelTransitions.restartAtBeginning()
	get_tree().paused = false



func _on_loadChkptButton_pressed():
	var confirm = confirmPkdScn.instance()
	add_child(confirm)
	confirm.setup("Load last checkpoint?",
				"Yes", self, "onLoadChkptConfirmed",
				"No")


func onLoadChkptConfirmed():
	LevelTransitions.restartAtCheckpointOrBeginning()
	get_tree().paused = false

