extends Area2D

export var speed : float = 700

onready var animatedSprite = $'AnimatedSprite'
onready var explosionSound = $'ExplosionSound2D'

var velocity = null
var exploding = false


var sndDone = false
var animationDone = false

func _ready():
	velocity = Vector2(0, -speed).rotated(deg2rad(self.rotation_degrees))




func _physics_process(delta):
	self.position += velocity * delta

func _on_Missle_body_entered(body):
	if exploding:
		return
#	print('missle body entered' )
	if body.is_in_group('player'):
		print('hit player')
		body.collideWith(self)
	animatedSprite.play('explode')
	explosionSound.play()
	exploding = true
	velocity = Vector2()


func maybeFree():
	if sndDone and animationDone:
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if exploding:
		animationDone = true
		animatedSprite.queue_free()
		maybeFree()



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ExplosionSound2D_finished():
	sndDone = true
	maybeFree()
