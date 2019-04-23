extends Panel



onready var indicators = {
 	'blue' : $hbox/Blue,
 	'green' : $hbox/Green,
 	'red' : $hbox/Red,
	'yellow' : $hbox/Yellow
}

var COLLECTED_MODULATE = Color(1,1,1,1)
var NOT_COLLECTED_MODULATE = Color(1,1,1,0.3)


func setGems(gems):

	if gems == null:
		for ind in indicators.values():
			ind.visible = false
		return


	for color in indicators.keys():
		if color in gems.keys():
			indicators[color].visible = true
			indicators[color].modulate = COLLECTED_MODULATE if gems[color] else NOT_COLLECTED_MODULATE
		else:
			indicators[color].visible = false
