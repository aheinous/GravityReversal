extends CanvasLayer

onready var msgLabel = $msgLabel
onready var msgTimer = $msgTimer
onready var coinCntLbl = $CoinCounter/Panel/HBoxContainer/Number
onready var gemIndicator = $MarginContainer/GemIndicator


func setCoinCount(cnt):
	print('setCoinCount(', cnt, ')')
	coinCntLbl.text = str(cnt)

func _ready():
	clearMsg()
	msgLabel.show()


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



func setGems(gems):
	print('HUD.setGems(',gems, ')')
	gemIndicator.setGems(gems)
	if gems.size() == 0:
		gemIndicator.visible = false


