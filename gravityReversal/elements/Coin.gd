extends Area2D


var particles
onready var animation = $CoinAnimation
onready var sndfx = $AudioStreamPlayer

var consumed = false


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		print("GLES2")
		particles = $CPUParticles2D
	else:
		print("GLES3")
		particles = $Particles2D

func registerCoin():
	animation.visible = false
	get_tree().get_current_scene().onCoin(1)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func _on_Coin_area_entered(area):
	if area.is_in_group('player') and not consumed:
		consumed = true
		particles.emitting = true
		sndfx.play()
		CheckpointSys.recordEvent(self, 'registerCoin')

