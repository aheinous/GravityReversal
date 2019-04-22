extends Node2D


export var speed = 1000
export var phase = 0.0

onready var animationPlayer = $AnimationPlayer
onready var follow = $Path/Follow
onready var path = $Path

var pathDir = 1

func _ready():
	animationPlayer.play('spin')

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

