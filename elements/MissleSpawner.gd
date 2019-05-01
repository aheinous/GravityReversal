extends Node2D

export var missleSpeed : float = 1000
export var interval : float = 1
export var phase : float = 0


const missleScene = preload('res://elements/Missle.tscn')

onready var spawnPos = $'spawnPoint'.global_position
onready var timer = $Timer
onready var launchSound = $LaunchSoundPlayer2D

func _ready():
	assert(phase >= 0 and phase <= 1)
	reset()

#var totalTime = 0
#
#func _process(delta):
#	totalTime += delta


func reset():
	timer.stop()
	timer.wait_time = interval
	var delay = (1-phase) * interval
#	print('[',totalTime, '] pause for ', delay)
	yield(get_tree().create_timer(delay), "timeout")
#	print('[',totalTime, '] pause done')
	spawn()
	timer.start()

func spawn():
#	print('[',totalTime, '] spawn')
	launchSound.play()

	var missleInstance = missleScene.instance()
	missleInstance.position = spawnPos
	missleInstance.rotation_degrees = self.rotation_degrees - 90
#	print('sp: ', spaw)
	if missleSpeed != 0:
		missleInstance.speed = missleSpeed
	get_tree().get_current_scene().add_child(missleInstance)


func _on_Timer_timeout():
	spawn()
