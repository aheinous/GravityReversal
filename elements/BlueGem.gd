extends Area2D


onready var particles = $Particles2D
onready var sprite = $Sprite
onready var sndfx = $AudioStreamPlayer


export var color = 'blue'


func _on_Coin_area_entered(area):
	if area.is_in_group('player'):
		sprite.visible = false
		particles.emitting = true
		sndfx.play()
		get_tree().get_current_scene().onGem(color)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
