extends KinematicBody2D



class StateMachine:
	var state = null
	var prevState = null
	var states = {}
	var transitionFunc = null

	func _init(transitionFunc, states):
		self.transitionFunc = transitionFunc
		for state in states:
			self.addState(state)

	func addState(state):
		self.states[state] = self.states.size()

	func setState(newState):
		if newState == state:
			return
		prevState = state
		state = newState
		transitionFunc.call_func(newState, prevState)


export var invincible := false
export var zoom = 1.0 setget setZoom, getZoom


const GRAVITY = 550
const WALK_SPEED = 400
const CAMERA_CENTER_DEFAULT = Vector2(700, 0)
const FLIP_SPEED = 3

onready var animatedSprite = $AnimationWrapper/RobotAnimations
#onready var animationWrapper = $AnimationWrapper
onready var animationPlayer = $AnimationPlayer
onready var flipNoise = $FlipNoise


var moveDir = Vector2.RIGHT
var fallDir = Vector2.DOWN
var velocity = Vector2.ZERO
var upsideDown = false
var angleDegrees = 0

var gameSM = StateMachine.new(
		funcref(self, 'onGameStateTransition'),
		[
			'waiting',
			'moving',
			'dead',
			'finished'
		])



func onGameStateTransition(newState, prevState):
	match newState:
		gameSM.states.dead:
#			animatedSprite.play("dead")
			animationPlayer.queue("DeathPhysCollision")
			owner.playerDied()
		gameSM.states.finished:
			owner.playerReachedGoal()

func startMoving():
	gameSM.setState(gameSM.states.moving)



func setMovement(angle, upsideDown, animate = false):

	angle = centerAnglePos(angle)
	var prevAngle = self.angleDegrees

	self.angleDegrees = angle
	self.rotation_degrees = angle
	self.moveDir = Vector2.RIGHT.rotated(deg2rad(angle))
	self.fallDir = Vector2.RIGHT.rotated(deg2rad(angle-90 if upsideDown else angle+90))

	self.scale.y = -1 if upsideDown else 1

	var isFlip = (self.upsideDown != upsideDown)
	self.upsideDown = upsideDown

	if not animate:
		return

	var animation = Animation.new()
	var trackIdx = animation.add_track(Animation.TYPE_VALUE)

	var rot = prevAngle - angle
	if isFlip:
		rot += 180
	if upsideDown:
		rot = -rot
	rot = centerAnglePos(rot)

#	print('rot: %s, prevAngle: %s, angle: %s, isFlip: %s, upsideDown: %s' % [rot, prevAngle, angle, isFlip, upsideDown ])

	animation.track_set_path(trackIdx, "AnimationWrapper:rotation_degrees")
	animation.track_insert_key(trackIdx, 0.0, rot)
	animation.track_insert_key(trackIdx, 1.0, 0)

	var error = 0
	error = animationPlayer.add_animation('generatedFlip', animation)
	assert(error == 0)

	animationPlayer.play('generatedFlip',-1, FLIP_SPEED*(360.0/rot))



func changeDirectionToMatchSurface(tileMap):
	var choiceA = centerAngle(tileMap.rotation_degrees)
	var choiceB = centerAngle(tileMap.rotation_degrees + 180)

	var startAng = self.angleDegrees
	var canidate = choiceA if abs(centerAngle(choiceA-startAng)) < abs(centerAngle(choiceB-startAng)) else choiceB

	if abs(centerAngle(startAng - canidate)) > 50 or startAng == canidate:
		return

	changeDirectionToAngle(canidate)


func reverseGravity():
	setMovement(angleDegrees, not upsideDown, true)
	flipNoise.play()


func _physics_process(delta):
	# zero velocity in moveDir direction
	velocity -= moveDir * velocity.dot(moveDir)
	if gameSM.state == gameSM.states.moving:
		# set veloctiy to WALK_SPEED in moveDir direction
		velocity += moveDir * WALK_SPEED

	var acceleration = GRAVITY * fallDir * delta
	velocity += acceleration
	velocity = move_and_slide(velocity, -fallDir)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group('bomb'):
			var validHit = collision.collider.onPlayerHit(self, collision)
			if validHit:
				collideWith(collision.collider)
		else:
			collideWith(collision.collider)
	selectAnimation()


func selectAnimation():
	if gameSM.state != gameSM.states.dead:
		if is_on_floor():
			animatedSprite.play('run' if gameSM.state == gameSM.states.moving else 'idle')
		else:
			animatedSprite.play('jump')
	else:
		animatedSprite.play('dead')


func _input(event):
	if  ((event is InputEventScreenTouch and event.pressed)
			or Input.is_action_just_pressed("ui_accept")):
		reverseGravity()


func getHit():
	if invincible:
		return
	if not gameSM.state in [gameSM.states.waiting, gameSM.states.moving]:
		return
	gameSM.setState(gameSM.states.dead)


func reachGoal():
	if gameSM.state == gameSM.states.moving:
		gameSM.setState(gameSM.states.finished)


func collideWith(other):
	if other.is_in_group('evil'):
		getHit()
	if other.is_in_group('goal'):
		reachGoal()
#	if other.is_in_group('good'):
#		changeDirectionToMatchSurface(other)


static func centerAngle(deg):
	while deg > 180:
		deg -= 360
	while deg <= -180:
		deg += 360
	return deg


static func centerAnglePos(deg):
	while deg >= 360:
		deg -= 360
	while deg < 0:
		deg += 360
	return deg


static func centerAngleNeg(deg):
	while deg > 0:
		deg -= 360
	while deg <= -360:
		deg += 360
	return deg


func changeDirectionToAngle(angleDeg):
	if self.angleDegrees == angleDeg:
		return

	var upsideDown = self.upsideDown

	var absDeltaDegrees = abs(centerAngle(angleDeg - self.angleDegrees))
	if ( absDeltaDegrees > 91):
		upsideDown = not upsideDown

	# if angle change is close to 90 degrees set upsideDown in the way most consistant with current velocity
	if 89 < absDeltaDegrees and absDeltaDegrees < 91:
		var fallDir = Vector2.RIGHT.rotated(deg2rad(angleDeg-90 if upsideDown else angleDeg+90))
		if fallDir.dot(velocity) < 0:
			upsideDown = not upsideDown

	setMovement(angleDeg, upsideDown, true)


func setZoom(newZoom):
	zoom = newZoom
	$CameraCenter.position = CAMERA_CENTER_DEFAULT * zoom
	$CameraCenter/Camera2D.zoom = Vector2(zoom,zoom)


func getZoom():
	return zoom

func _on_Sense_area_entered(area):
	# print('_on_Sense_area_entered(area): area = ', area)
	if area.is_in_group("directionChanger"):
		changeDirectionToAngle(area.rotation_degrees)

