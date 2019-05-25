extends KinematicBody2D

const GRAVITY = 550
const WALK_SPEED = 400
const CAMERA_CENTER_DEFAULT = Vector2(700, 0)
const FLIP_SPEED = 6

onready var animatedSprite = $RobotAnimations
onready var animationPlayer = $AnimationPlayer
onready var flipNoise = $FlipNoise

enum  {STALLED, MOVING, DYING, DEAD, REACHED_GOAL}


var moveDir = Vector2.RIGHT
var velocity = Vector2.ZERO
var state = STALLED

var upsideDown = false

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


func reverse_gravity(stealth = false):
	if not stealth and (state == DEAD or state == DYING):
		return
	flipAnimation(stealth)
	if not stealth:
		flipNoise.play()
#	fallDir *= -1
	upsideDown = not upsideDown

func getFallDir():
	if upsideDown:
		return moveDir.rotated(deg2rad(-90))
	else:
		return moveDir.rotated(deg2rad(90))



static func centerAngle(deg):
	while deg > 180:
		deg -= 360
	while deg < -180:
		deg += 360
	return deg

func changeDirectionToMatchSurface(tileMap):
	var choiceA = centerAngle(tileMap.rotation_degrees)
	var choiceB = centerAngle(tileMap.rotation_degrees + 180)

	var startAng = self.rotation_degrees
	var canidate = choiceA if abs(centerAngle(choiceA-startAng)) < abs(centerAngle(choiceB-startAng)) else choiceB

	if abs(centerAngle(startAng - canidate)) > 50 or startAng == canidate:
		return

	changeDirectionToAngle(canidate)


func changeDirectionToAngle(deg):
	if deg == self.rotation_degrees:
		return


	var needGravReverse = (abs(centerAngle(deg - self.rotation_degrees)) > 90)

	self.rotation_degrees = deg

	var newMoveDir = Vector2.RIGHT.rotated(deg2rad(deg))
	if newMoveDir != moveDir:
		print('moveDir: %s -> %s' % [moveDir, newMoveDir])
	moveDir = newMoveDir
	if needGravReverse:
		reverse_gravity(true)

func isUpsideDown():
#	return (fallDir != Vector2(0,1))
	return upsideDown

func flipAnimation(instant = false):
	animationPlayer.play("flip",
							-1,
							-FLIP_SPEED if isUpsideDown() else FLIP_SPEED,
							isUpsideDown())
	if instant:
		animationPlayer.seek(0 if isUpsideDown() else animationPlayer.current_animation_length)


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
	var acceleration = GRAVITY * getFallDir() * delta
	velocity += acceleration
	velocity = move_and_slide(velocity, -getFallDir())

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
			var fallSpeed = abs(velocity.dot(getFallDir()))
			animatedSprite.play('jump')


func collideWith(other):
	if other.is_in_group('evil'):
		die()
	if other.is_in_group('goal'):
		reach_goal()
	if other.is_in_group('good'):
		changeDirectionToMatchSurface(other)



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
	# print('_on_Sense_area_entered(area): area = ', area)
	if area.is_in_group("directionChanger"):
		changeDirectionToAngle(area.rotation_degrees)





