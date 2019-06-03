extends Node

var loader = null
var waitFrames = 1


func _ready():
	set_process(false)


func _process(delta):
	if loader == null:
		return
	if waitFrames > 0:
		waitFrames -= 1
		return

	var error = loader.wait()

	if error != ERR_FILE_EOF:
		print('Global.loadScene() error: %s' % error)
		return

	get_tree().change_scene_to(loader.get_resource())

	loader = null
	set_process(false)



func loadScene(path):
	loader = ResourceLoader.load_interactive(path)
	get_tree().change_scene_to(preload("res://menus/loadScreen.tscn"))
	waitFrames = 1
	set_process(true)

func reloadScene():
	get_tree().reload_current_scene()
