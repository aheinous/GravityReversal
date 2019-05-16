extends Node2D

export var missleSpeed : float = 1000
export var interval : float = 1
export var phase : float = 0


const missleScene = preload('res://elements/Missle.tscn')

onready var spawnPos = $'spawnPoint'.global_position
onready var timer = $Timer
onready var launchSound = $LaunchSoundPlayer2D

func _ready():
	var startPhase = phase
	phase = fmod(phase, 1.0)
	if phase < 0:
		phase += 1.0
	print('startPhase, phase: %f, %f' % [startPhase, phase])
	assert(phase >= 0 and phase < 1)
	reset()



var nextLaunch = 0.0

func reset():
	timer.stop()
	nextLaunch = Global.getTime() + (1.0-phase) * interval
	startTimer()




func spawn():
	# print('[%s] [%f] spawn' % [name, Global.getTime()])
	launchSound.play()

	var missleInstance = missleScene.instance()
	missleInstance.position = spawnPos
	missleInstance.rotation_degrees = self.rotation_degrees - 90
	if missleSpeed != 0:
		missleInstance.speed = missleSpeed
	get_tree().get_current_scene().add_child(missleInstance)



func startTimer():
	timer.start(max(0, nextLaunch - Global.getTime()))


func _on_Timer_timeout():
	spawn()
	nextLaunch += interval
	startTimer()

