extends Area2D


onready var particles = $Particles2D
onready var animation = $CoinAnimation
onready var sndfx = $AudioStreamPlayer

var consumed = false


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

