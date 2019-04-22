extends Area2D



export var speed : float = 700


onready var animatedSprite = $'AnimatedSprite'

var velocity = null

var exploding = false

func _ready():
	velocity = Vector2(0, -speed).rotated(deg2rad(self.rotation_degrees))




func _physics_process(delta):
	self.position += velocity * delta

func _on_Missle_body_entered(body):
	animatedSprite.play('explode')
	exploding = true
	velocity = Vector2()



func _on_AnimatedSprite_animation_finished():
	if exploding:
		queue_free()



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
