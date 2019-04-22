extends Node2D


const missleScene = preload('res://elements/Missle.tscn')

func _ready():
	pass


func spawn():
	var missleInstance = missleScene.instance()
	missleInstance.position = self.position
	get_tree().get_current_scene().add_child(missleInstance)


func _on_Timer_timeout():
	print('timer timeout')
	spawn()
