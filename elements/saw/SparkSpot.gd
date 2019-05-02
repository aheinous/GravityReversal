extends Area2D


onready var sparkEmitter = $'Particles2D'

var overlapping = {}




func _ready():
	pass



func onOverlappingChange():
#	print('overlapping size: ', overlapping.size())
	sparkEmitter.emitting = (overlapping.size() > 0)



func _on_SparkSpot_body_entered(body):
#	print('sparkSpot body entered:', body)
	overlapping[body] = true
	onOverlappingChange()


func _on_SparkSpot_body_exited(body):
#	print('sparkSpot body exited:', body)
	overlapping.erase(body)
	onOverlappingChange()
