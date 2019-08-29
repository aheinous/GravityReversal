extends Control



onready var indicators = {
	'blue' : $hbox/BlueRect/Blue,
	'green' : $hbox/GreenRect/Green,
	'red' : $hbox/RedRect/Red,
	'yellow' : $hbox/YellowRect/Yellow
}

onready var indicatorContainers = {
	'blue' : $hbox/BlueRect,
	'green' : $hbox/GreenRect,
	'red' : $hbox/RedRect,
	'yellow' : $hbox/YellowRect
}




var COLLECTED_MODULATE = Color(1,1,1,1)
var NOT_COLLECTED_MODULATE = Color(1,1,1,0.3)


func setGems(gems):

#	print('set gems:', gems)

	if gems == null:
		for ind in indicators.values():
			ind.visible = false
		return


	for color in indicators.keys():
		if color in gems.keys():
			indicatorContainers[color].visible = true
			indicators[color].modulate = COLLECTED_MODULATE if gems[color] else NOT_COLLECTED_MODULATE
		else:
			indicatorContainers[color].visible = false

#	print(self.rect_size, ' ',  $hbox.rect_size)
#
#	self.rect_size.x = $hbox.rect_size.x
#
#	print(self.rect_size, ' ',  $hbox.rect_size)
