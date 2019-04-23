extends CanvasLayer

onready var pauseScreen = $pauseScreen
onready var msgLabel = $msgLabel
onready var msgTimer = $msgTimer
onready var coinCntLbl = $CoinCounter/Panel/Number
onready var gemIndicator = $MarginContainer/GemIndicator

#func _enter_tree():
#	level_manager.HUD = self
#
#func _exit_tree():
#	level_manager.HUD = null


func setCoinCount(cnt):
	print('setCoinCount(', cnt, ')')
	coinCntLbl.text = str(cnt)

func _ready():
	clear_msg()
	msgLabel.show()
	pauseScreen.hide()


func pause():
	msgLabel.hide()
	pauseScreen.show()


func unpause():
	msgLabel.show()
	pauseScreen.hide()


func clear_msg():
	$msgLabel.text = ''


func show_msg(txt, timeout=2):
#	print('showing message: ', txt)
	msgTimer.stop()
	msgLabel.text = txt
	if timeout > 0:
		$msgTimer.start(timeout)


func _on_msgTimer_timeout():
	clear_msg()


func _on_continueButton_pressed():
	owner.togglePause()


func _on_quitButton_pressed():
	owner.quitToMainMenu()


func setGems(gems):
	print('HUD.setGems(',gems, ')')
	gemIndicator.setGems(gems)