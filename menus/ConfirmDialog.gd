extends Control

signal YesPressed
signal NoPressed

#onready var TextLabel = $'MarginContainer/ColorRect/VBoxContainer/QuestionText'
#onready var YesButton = $'MarginContainer/ColorRect/VBoxContainer/HBoxContainer/YesButton'
#onready var NoButton = $'MarginContainer/ColorRect/VBoxContainer/HBoxContainer/NoButton'


#onready var TextLabel = $'ColorRect/VBoxContainer/QuestionText'
#onready var YesButton = $'ColorRect/VBoxContainer/HBoxContainer/YesButton'
#onready var NoButton = $'ColorRect/VBoxContainer/HBoxContainer/NoButton'

onready var TextLabel = $'CenterContainer/VBoxContainer/QuestionText'
onready var YesButton = $'CenterContainer/VBoxContainer/HBoxContainer/YesButton'
onready var NoButton = $'CenterContainer/VBoxContainer/HBoxContainer/NoButton'






func setup(text, yesText, yesTgt, yesMethod, noText, noTgt=null, noMethod=null):
	TextLabel.text = text

	YesButton.text = yesText
	NoButton.text = noText

	connect("YesPressed", yesTgt, yesMethod)
	if noTgt != null and noMethod != null:
		connect("NoPressed", noTgt, noMethod)



func _on_YesButton_pressed():
	emit_signal("YesPressed")
	queue_free()


func _on_NoButton_pressed():
	emit_signal("NoPressed")
	queue_free()
