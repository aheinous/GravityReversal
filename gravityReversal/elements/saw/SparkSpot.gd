extends Area2D


onready var sparkEmitter = $'Particles2D'

var nOverlapping = 0


func _ready():
	pass



func _on_SparkSpot_body_entered(body):
	nOverlapping += 1
	sparkEmitter.emitting = true


func _on_SparkSpot_body_exited(body):
	nOverlapping -= 1
	sparkEmitter.emitting = (nOverlapping > 0)
