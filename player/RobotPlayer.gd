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
		if collision.collider.is_in_group('bomb'):
			collision.collider.onPlayerHit(self, collision)
		collideWith(collision.collider)



	if  state != DEAD and state != DYING:
		if is_on_floor():
			animatedSprite.play('run' if state == MOVING else 'idle')
		else:
			var fallSpeed = abs(velocity.dot(fallDir))
			animatedSprite.play('jump')

func collideWith(other):
	if other.is_in_group('evil'):
		die()
	if other.is_in_group('goal'):
		reach_goal()



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
	state = REACHED_GOAL
	owner.player_reached_goal()



func _on_AnimatedSprite_animation_finished():
	if state == DYING:
		state = DEAD


func _on_Sense_area_entered(area):
	# for saws/ missles
	# print('_on_Sense_area_entered(area): area = ', area)
	collideWith(area)

