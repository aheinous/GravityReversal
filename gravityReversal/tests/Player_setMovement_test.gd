extends "res://Level.gd"


#onready var player = $Player

func _ready():
	pass


func isKeypress(event, scancode):
	return event is InputEventKey and event.scancode == scancode and event.is_pressed() and not event.echo

func _input(event):
	if isKeypress(event, KEY_1):
		player.setMovement(player.angleDegrees+90, player.upsideDown, true)
	elif isKeypress(event, KEY_2):
		player.setMovement(player.angleDegrees+180, player.upsideDown, true)
	elif isKeypress(event, KEY_3):
		player.setMovement(player.angleDegrees+270, player.upsideDown, true)
	elif isKeypress(event, KEY_4):
		player.setMovement(player.angleDegrees+0, not player.upsideDown, true)
	elif isKeypress(event, KEY_5):
		player.setMovement(player.angleDegrees+90, not player.upsideDown, true)
	elif isKeypress(event, KEY_6):
		player.setMovement(player.angleDegrees+180, not player.upsideDown, true)
	elif isKeypress(event, KEY_7):
		player.setMovement(player.angleDegrees+270, not player.upsideDown, true)
	elif isKeypress(event, KEY_8):
		pass
	elif isKeypress(event, KEY_9):
		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass
#	elif isKeypress(event, KEY_7):
#		pass

