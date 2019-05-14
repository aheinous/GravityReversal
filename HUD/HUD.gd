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
	togglePause()


func onQuitConfirmed():
	owner.quitToMainMenu()


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
	get_tree().reload_current_scene()
	get_tree().paused = false

