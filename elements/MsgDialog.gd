extends CanvasLayer

signal Closed

onready var TextLabel = $'CenterContainer/PanelContainer/VBoxContainer/MsgText'
onready var OkayButton = $'CenterContainer/PanelContainer/VBoxContainer/MarginContainer/OkayButton'


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		_on_OkayButton_pressed()


func setup(msgTxt, buttonTxt, onClose_Tgt=null, onClose_method=null):
	TextLabel.text = msgTxt
	OkayButton.text = " " + buttonTxt + " "
	if onClose_Tgt != null and onClose_method != null:
		connect("Closed", onClose_Tgt, onClose_method)
	get_tree().paused = true


func _on_OkayButton_pressed():
	emit_signal("Closed")
	get_tree().paused = false
	queue_free()
