extends Area2D


onready var particles = $Particles2D
onready var animation = $CoinAnimation
onready var sndfx = $AudioStreamPlayer

func _ready():
	pass


func _on_Coin_area_entered(area):
	if area.is_in_group('player'):
		animation.visible = false
		particles.emitting = true
		sndfx.play()
		get_tree().get_current_scene().onCoin(1)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
