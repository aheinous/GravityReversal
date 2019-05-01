extends KinematicBody2D

const GRAVITY = 550
const WALK_SPEED = 400
const CAMERA_CENTER_DEFAULT = Vector2(700, 0)

onready var animatedSprite = $RobotAnimations

enum  {STALLED, MOVING, DYING, DEAD, REACHED_GOAL}

var fallDir = Vector2(0,1)
var moveDir = Vector2(1,0)
var velocity = Vector2()
var state = STALLED

export var zoom = 1.0 setget setZoom, getZoom


func setZoom(newZoom):
	zoom = newZoom
	$CameraCenter.position = CAMERA_CENTER_DEFAULT * zoom
	$CameraCenter/Camera2D.zoom = Vector2(zoom,zoom)


func getZoom():
	return zoom


func start_moving():
	state = MOVING


func reverse_gravity():
	if state == DEAD or state == DYING:
		return
	fallDir *= -1
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

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		# print('player collision no. ', i, ': ', collision)
		# print("Collided with: ", collision.collider.name)
		if collision.collider.is_in_group('bomb'):
			collision.collider.onPlayerHit(self, collision)



	if  state != DEAD and state != DYING:
		if is_on_floor():
			animatedSprite.play('run' if state == MOVING else 'idle')
		else:
			var fallSpeed = abs(velocity.dot(fallDir))
			animatedSprite.play('jump')



func die():
	print('dying!!!!')
	if state != STALLED and state != MOVING:
		return
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
	# print('sense body entered by: ', body, body.is_in_group("evil"))

	# if body.is_in_group('bomb'):
	# 	print('hit bomb!')
	# 	# body.onPlayerHit(self)

	if body.is_in_group("evil"):
		die()
	elif body.is_in_group("goal"):
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



func _on_Sense_area_entered(area):
#	print('_on_Sense_area_entered(area): area = ', area)
	if area.is_in_group('evil'):
		die()


#
#func _on_Sense_area_shape_entered(area_id, area, area_shape, self_shape):
#	print('_on_Sense_area_shape_entered(area_id, area, area_shape, self_shape): ', area_id, ', ', area, ', ', area_shape, ', ', self_shape)
