extends Control


const confirmScn = preload('res://menus/ConfirmDialog.tscn')

onready var fxSlider = $'CenterContainer/VBoxContainer/VBoxContainer/FX_HBoxContainer/fx_slider'
onready var musicSlider = $'CenterContainer/VBoxContainer/VBoxContainer/Music_HBoxContainer/music_slider'

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		goBack()



func _ready():
	initVolumeSliderValues()

func _exit_tree():
	level_manager.saveGame()

func _on_ResetButton_pressed():
	var confirm = confirmScn.instance()
	add_child(confirm)
	confirm.setup("Really reset save data?",
				"Yes", self, "onYesPressed",
				"No")


func onYesPressed():
	level_manager.clearSaveData()


#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
#		goBack()
#
#func _process(delta):
#	if Input.is_action_just_pressed("ui_cancel"):
#		goBack()

func goBack():
#	get_tree().change_scene("menus/Menu.tscn")
	queue_free()


func initVolumeSliderValues():

	var busIdx
	var dB
	var sliderValue

	# Music
	busIdx = AudioServer.get_bus_index("music")
	dB = AudioServer.get_bus_volume_db(busIdx)
	sliderValue = inverse_lerp(-70, 0, dB) * 100
	if AudioServer.is_bus_mute(busIdx):
		sliderValue = 0
	musicSlider.value = sliderValue

	# FX
	busIdx = AudioServer.get_bus_index("fx")
	dB = AudioServer.get_bus_volume_db(busIdx)
	sliderValue = inverse_lerp(-70, 0, dB) * 100
	if AudioServer.is_bus_mute(busIdx):
		sliderValue = 0
	fxSlider.value = sliderValue




func onNewVolumeSliderValue(busName, value):
	var dB = lerp(-70.0, 0.0, value/100.0)
	var busIdx = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_mute(busIdx, value == 0)
	AudioServer.set_bus_volume_db(busIdx, dB)


func _on_music_slider_value_changed(value):
	onNewVolumeSliderValue("music", value)
#	print(value)


func _on_fx_slider_value_changed(value):
	onNewVolumeSliderValue("fx", value)
