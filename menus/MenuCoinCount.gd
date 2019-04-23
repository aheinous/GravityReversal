extends Panel


onready var icon = $CoinIcon
onready var label = $CoinCount

var blank = false setget setBlank, getBlank

#var isReady = false
#
#
#func _ready():
#	isReady = true
#	setBlank(blank)

func setCoinCount(num, denum):
	label.text = str(num) + ' / ' + str(denum)

func setBlank(val):
	print('setBlank(', val, ')')
	blank = val
#	if isReady:
	icon.visible = not blank
	label.visible = not blank
	print(icon.visible, label.visible)

func getBlank():
	return blank