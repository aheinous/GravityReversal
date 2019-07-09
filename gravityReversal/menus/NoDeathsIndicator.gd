extends Control


var blank = false setget setBlank
var noDeaths = false setget setNoDeaths

func _ready():
	setNoDeaths(false)

func setNoDeaths(noDeaths_):
	noDeaths = noDeaths_
	updateVisible()

func setBlank(blank_):
	blank = blank_
	updateVisible()


func updateVisible():
	$Label.visible = not blank
	$YesTexture.visible = (not blank) and noDeaths
	$NoTexture.visible = (not blank) and (not noDeaths)