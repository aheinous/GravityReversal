extends AnimatedSprite

onready var Sound = $AudioStreamPlayer

var soundDone = false
var animationDone = false

func _ready():
#	print('EXPLOSION READY')
	play()
	Sound.play()


func maybeFree():
	if soundDone and animationDone:
#		print('EXPLOSION FREE')
		queue_free()

func _on_Explosion_animation_finished():
#	print('EXPLOSION ANIMATION DONE')
	animationDone = true
	maybeFree()

func _on_AudioStreamPlayer_finished():
#	print('EXPLOSION SOUND DONE')
	soundDone = true
	maybeFree()

