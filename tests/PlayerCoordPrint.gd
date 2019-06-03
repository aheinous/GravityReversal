extends "res://player/Player.gd"

func _ready():
	pass



var nextPrint = 0

func _process(delta):
	if Global.getTime() >= nextPrint:
		nextPrint += 1
		print('play pos: ', self.position)
