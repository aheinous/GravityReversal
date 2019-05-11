extends Area2D

export var msg := ""
export var buttonTxt := ""


#func _on_cameraChange_area_entered(area):
#	if area.is_in_group('player'):
#		tween.interpolate_property(player, 'zoom', player.zoom, newZoom, transitionTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.start()
#


#func onMsgConfirmed():
#	print("msgConfirmed")


func _on_MsgTrigger_area_entered(area):
#	pass # Replace with function body.
	var msgDialog = preload("res://elements/MsgDialog.tscn").instance()
	owner.add_child(msgDialog)
	msgDialog.setup(msg, buttonTxt)
#	get_tree().paused = true