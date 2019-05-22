extends KinematicBody2D

const GRAVITY = 550
const WALK_SPEED = 400
const CAMERA_CENTER_DEFAULT = Vector2(700, 0)
const FLIP_SPEED = 6

onready var animatedSprite = $RobotAnimations
onready var animationPlayer = $AnimationPlayer

enum  {STALLED, MOVING, DYING, DEAD, REACHED_GOAL}

var fallDir = Vector2(0,1)
var moveDir = Vector2(1,0)
var velocity = Vector2()
var state = STALLED

export var zoom = 1.0 setget setZoom, getZoom
export var invincible := false


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
	flipAnimation()
	fallDir *= -1


func isUpsideDown():
	return (fallDir != Vector2(0,1))

func flipAnimation():
	animationPlayer.play("flip",
							-1,
							-FLIP_SPEED if isUpsideDown() else FLIP_SPEED,
							isUpsideDown())


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
			var validHit = collision.collider.onPlayerHit(self, collision)
			if validHit: collideWith(collision.collider)
		else:
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
	if invincible:
		return
	if state != STALLED and state != MOVING:
		return
	# start death animation first to avoid race condition of _on_AnimatedSprite_animation_finished()
	# getting called immediately after death starts
	animatedSprite.play("dead")
	animationPlayer.queue("DeathPhysCollision_flipped" if isUpsideDown() else "DeathPhysCollision")

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
#	print('skipping ')
#	collideWith(area)
	pass

