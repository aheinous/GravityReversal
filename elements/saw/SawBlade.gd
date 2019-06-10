extends Node2D


export var speed := 100
export (float, 0, 1) var phase = 0.0
export var pauseTime := 0.0

onready var animationPlayer = $AnimationPlayer
onready var follow = $Path/Follow
onready var path = $Path
onready var runningSound = $'Path/Follow/Blade/RunningSound2D'
onready var hitSound = $'Path/Follow/Blade/HitSound2D'
onready var curveDrawer = $TextureCurveDrawer

var curve = null
var pathDir = 1

var nOverlapping = 0

enum State {FWD_PAUSE, FWD, REV_PAUSE, REV}

var state = State.FWD_PAUSE
var curPauseRemaining

func _ready():
	animationPlayer.play('spin')
	runningSound.play()

	for child in get_children():
		if child is Path2D and child.name != 'Path':
			path.curve = child.curve
			self.curve = child.curve
			break

	reset()


func _draw():
	curveDrawer.drawCurve(self, curve)

func reset():
	curPauseRemaining = pauseTime
	var totalPeriodTime = 2*pauseTime + 2*path.curve.get_baked_length()/speed
	_physics_process(totalPeriodTime * phase)

func _physics_process(delta):
	while delta > 0:
		var startOffset = follow.offset
		match state:
			State.FWD_PAUSE:
				if curPauseRemaining >= delta:
					curPauseRemaining -= delta
					delta = 0
				else:
					delta -= curPauseRemaining
					curPauseRemaining = 0
				if curPauseRemaining <= 0.0:
					state = State.FWD
					curPauseRemaining = pauseTime
			State.FWD:
				follow.offset += speed*delta
				if follow.unit_offset >= 1:
					follow.unit_offset = 1
					delta -= (follow.offset-startOffset) / speed
					state = State.REV_PAUSE
				else:
					delta = 0
			State.REV_PAUSE:
				if curPauseRemaining >= delta:
					curPauseRemaining -= delta
					delta = 0
				else:
					delta -= curPauseRemaining
					curPauseRemaining = 0
				if curPauseRemaining <= 0.0:
					state = State.REV
					curPauseRemaining = pauseTime
			State.REV:
				follow.offset -= speed*delta
				if follow.unit_offset <= 0:
					follow.unit_offset = 0
					delta -= (startOffset-follow.offset) / speed
					state = State.FWD_PAUSE
				else:
					delta = 0



func _on_Blade_body_entered(body):

	if body.is_in_group('player'):
		print('saw hit player')
		body.collideWith(self)

	nOverlapping += 1
	hitSound.play()



func _on_Blade_body_exited(body):
	nOverlapping -= 1
	if nOverlapping == 0:
		hitSound.stop()
