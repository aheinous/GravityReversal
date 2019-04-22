extends KinematicBody2D

const GRAVITY = 550
const WALK_SPEED = 400

var fallDir = Vector2(0,1)
var moveDir = Vector2(1,0)

var velocity = Vector2()

onready var animatedSprite = $FlatboyAnimations

enum  {STALLED, MOVING, DYING, DEAD, REACHED_GOAL}

var state = STALLED

func start_moving():
#	print('player starting to move.')
	state = MOVING



func reverse_gravity():
	if state == DEAD or state == DYING:
		return
	fallDir *= -1
	# animatedSprite.flip_v = not animatedSprite.flip_v
	self.scale.y *= -1


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		reverse_gravity()


func _physics_process(delta):
	# zero velocity in moveDir direction
	velocity -= moveDir * velocity.dot(moveDir)
	if state == MOVING:
		# set veloctiy to WALK_SPEED in moveDir direction
		velocity += moveDir * WALK_SPEED

	if Input.is_action_just_pressed("ui_accept"):
		reverse_gravity()
	var acceleration = GRAVITY * fallDir * delta
	velocity += acceleration
	velocity = move_and_slide(velocity, -fallDir)

	if  state != DEAD and state != DYING:
		if is_on_floor():
			animatedSprite.play('run' if state == MOVING else 'idle')
		else:
			var fallSpeed = abs(velocity.dot(fallDir))
			print('fallSpeed: ', fallSpeed)
#			animatedSprite.stop()
#			animatedSprite.set_animation('jump')
			animatedSprite.play('jump')
#			var frame = round(lerp(1,11, min(1.0, fallSpeed/400)))
#			print('frame: ', frame)
#			animatedSprite.frame = frame


func die():
	# start death animation first to avoid race condition of _on_AnimatedSprite_animation_finished()
	# getting called immediately after death starts
	animatedSprite.play("dead")
	$AnimationPlayer.play("DeathPhysCollision")
	state = DYING
	owner.player_died()


func reach_goal():
	if state != MOVING:
		return
	print("player reached goal")
#	emit_signal("reached_goal")
	state = REACHED_GOAL
	owner.player_reached_goal()


func _on_Sense_body_entered(body):
	#print('sense body entered by: ', body, body.is_in_group("evil_tile"), body.is_in_group("good_tile"))

	if body.is_in_group("evil_tile"):
		print("die!!!")
		die()
	elif body.is_in_group("goal_tile"):
		reach_goal()


#func _on_Sense_body_exited(body):
#	pass # Replace with function body.
#	#print('sense body exited by: ', body)
#
#
#func _on_Sense_body_shape_entered(body_id, body, body_shape, area_shape):
#	pass # Replace with function body.
#	#print('sense body shape entered by: ', body)
#
#
#func _on_Sense_body_shape_exited(body_id, body, body_shape, area_shape):
#	pass # Replace with function body.
#	#print('sense body shape exited by: ', body)


func _on_AnimatedSprite_animation_finished():
	if state == DYING:
		state = DEAD
		print('death complete')



