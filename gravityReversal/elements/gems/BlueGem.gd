extends Area2D


onready var particles = $Particles2D
onready var sprite = $Sprite
onready var sndfx = $AudioStreamPlayer


export var color = 'blue'

var consumed = false



func _ready():
	match color:
		'blue':
			particles.modulate = Color(0, 0.3, 1)
		'red':
			particles.modulate = Color(1, 0, 0)
		'green':
			particles.modulate = Color(0, 1, 0)
		'yellow':
			particles.modulate = Color(1, 1, 0)
		_:
			assert(false)


func registerGem():
	sprite.visible = false
	get_tree().get_current_scene().onGem(color)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func _on_Coin_area_entered(area):
	if area.is_in_group('player') and not consumed:
		consumed = true
		particles.emitting = true
		sndfx.play()
		CheckpointSys.recordEvent(self, 'registerGem')
