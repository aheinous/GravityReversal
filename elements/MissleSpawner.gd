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

#var totalTime = 0
#
#func _process(delta):
#	totalTime += delta


#func reset():
#	print('[%s] [%f] reset' % [name, totalTime])
#	timer.stop()
#	timer.wait_time = interval
#	var delay = (1-phase) * interval
##	print('[',totalTime, '] pause for ', delay)
#	print('[%s] [%f] -> yield delay=%f' % [name, totalTime, delay])
#	yield(get_tree().create_timer(delay), "timeout")
#	print('[%s] [%f] <- yield ' % [name, totalTime])
##	print('[',totalTime, '] pause done')
#	spawn()
#	timer.start()




var nextLaunch = 0.0

func reset():
	print('[%s] resetting ...' % name)
	timer.stop()
	nextLaunch = Global.getTime() + (1.0-phase) * interval
#	run()
	startTimer()

#func run():
#	while true:
#		var delay = max(0, nextLaunch - Global.getTime())
#		yield(get_tree().create_timer(delay), "timeout")
#		nextLaunch += interval
#		spawn()


func spawn():
	print('[%s] [%f] spawn' % [name, Global.getTime()])
	launchSound.play()

	var missleInstance = missleScene.instance()
	missleInstance.position = spawnPos
	missleInstance.rotation_degrees = self.rotation_degrees - 90
#	print('sp: ', spaw)
	if missleSpeed != 0:
		missleInstance.speed = missleSpeed
	get_tree().get_current_scene().add_child(missleInstance)



func startTimer():
	timer.start(max(0, nextLaunch - Global.getTime()))


func _on_Timer_timeout():
	spawn()
	nextLaunch += interval
	startTimer()



#func _on_Timer_timeout():
#	spawn()
