extends Area2D


export var newZoom : float = 0.5
export var transitionTime : float = 0.5
#export (Tween.TransitionType) var transitionType = Tween.TRANS_LINEAR
#export var easeType := Tween.EASE_IN_OUT



onready var player = get_tree().get_current_scene().get_node('Player')
onready var tween = $Tween


func _on_cameraChange_area_entered(area):
	if area.is_in_group('player'):
		tween.interpolate_property(player, 'zoom', player.zoom, newZoom, transitionTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

