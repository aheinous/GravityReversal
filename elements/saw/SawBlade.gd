extends Node2D


export var speed := 100
export var phase := 0.0
#export var pauseTime := 0.0

onready var animationPlayer = $AnimationPlayer
onready var follow = $Path/Follow
onready var path = $Path
onready var runningSound = $'RunningSound2D'
onready var hitSound = $'HitSound2D'

var pathDir = 1
var overlapping = {}

func _ready():
	animationPlayer.play('spin')
	runningSound.play()

	for child in get_children():
		if child is Path2D and child.name != 'Path':
			path.curve = child.curve
			break

	reset()


func reset():
	assert(phase >= 0 and phase <= 1)
	if phase < 0.5:
		pathDir = 1
		follow.unit_offset = phase*2.0
	else:
		pathDir = -1
		follow.unit_offset = 1.0 - (phase*2.0 - 1.0)


func _physics_process(delta):
	while true:
		var startOffset = follow.offset
		follow.offset += speed*delta*pathDir
		if follow.unit_offset <= 0:
			follow.unit_offset = 0
			delta -= (startOffset-follow.offset) / speed
			pathDir = 1
			continue
		elif follow.unit_offset >= 1:
			follow.unit_offset = 1
			delta -= (follow.offset-startOffset) / speed
			pathDir = -1
			continue
		break


func onOverlappingChange():
	if overlapping.size() > 0:
		hitSound.play()
	else:
		hitSound.stop()



func _on_Blade_body_entered(body):
#	hitSound.play()
#	print('saw body collide: ', body)
	if body.is_in_group('player'):
		print('saw hit player')
		body.collideWith(self)
	overlapping[body] = true
	onOverlappingChange()



func _on_Blade_body_exited(body):
	pass # Replace with function body.
	overlapping.erase(body)
	onOverlappingChange()
