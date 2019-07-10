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
onready var visibilityNotifier = $VisibilityNotifier2D

var curve = null
var nOverlapping = 0

var timeOffset = 0
var moveDuration
var totalPeriodDuration

func _ready():
	animationPlayer.play('spin')
	runningSound.play()

	for child in get_children():
		if child is Path2D and child.name != 'Path':
			path.curve = child.curve
			self.curve = child.curve
			break

	moveDuration = path.curve.get_baked_length()/speed
	totalPeriodDuration = 2*pauseTime + 2*moveDuration
	initVisibiltyNotifierRect()
	reset()


func initVisibiltyNotifierRect():
	var minx = INF
	var miny = INF
	var maxx = -INF
	var maxy = -INF
	for i in range(self.curve.get_point_count()):
		var pt = self.curve.get_point_position(i)
		minx = min(minx, pt.x)
		miny = min(miny, pt.y)
		maxx = max(maxx, pt.x)
		maxy = max(maxy, pt.y)
	minx -= 50
	miny -= 50
	maxx += 50
	maxy += 50
	visibilityNotifier.rect = Rect2(minx, miny, maxx-minx, maxy-miny)
	if visibilityNotifier.is_on_screen():
		_on_VisibilityNotifier2D_screen_entered();
	else:
		_on_VisibilityNotifier2D_screen_exited();


func _draw():
	curveDrawer.drawCurve(self, curve)


func reset():
	timeOffset = Global.getLevelTime() + totalPeriodDuration*phase


func _physics_process(delta):
	updateSawPos()

func updateSawPos():

	var timeSincePeriodStart = fposmod(Global.getLevelTime()+timeOffset, totalPeriodDuration)

	if timeSincePeriodStart <= pauseTime:
		follow.unit_offset = 0
	elif timeSincePeriodStart <= pauseTime + moveDuration:
		follow.unit_offset = (timeSincePeriodStart-pauseTime)/moveDuration
	elif timeSincePeriodStart <= 2*pauseTime + moveDuration:
		follow.unit_offset = 1
	else:
		follow.unit_offset = 1 - (timeSincePeriodStart-2*pauseTime-moveDuration)/moveDuration


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


func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)
	if nOverlapping >= 1:
		hitSound.play()


func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)
	hitSound.stop()
