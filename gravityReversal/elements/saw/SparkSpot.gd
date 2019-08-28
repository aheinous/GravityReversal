extends Area2D


var sparkEmitter

var nOverlapping = 0


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		sparkEmitter = $CPUParticles2D
	else:
		sparkEmitter = $Particles2D



func _on_SparkSpot_body_entered(body):
	nOverlapping += 1
	sparkEmitter.emitting = true


func _on_SparkSpot_body_exited(body):
	nOverlapping -= 1
	sparkEmitter.emitting = (nOverlapping > 0)
