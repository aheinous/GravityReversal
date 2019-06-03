extends Area2D


onready var particles = $Particles2D
onready var sprite = $Sprite
onready var sndfx = $AudioStreamPlayer


export var color = 'blue'


func registerGem():
	sprite.visible = false
	get_tree().get_current_scene().onGem(color)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func _on_Coin_area_entered(area):
	if area.is_in_group('player'):
		particles.emitting = true
		sndfx.play()
		CheckpointSys.recordEvent(self, 'registerGem')
