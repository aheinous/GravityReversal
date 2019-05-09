extends Area2D


const sparkSpotScn = preload('res://elements/saw/SparkSpot.tscn')

func _ready():
	var radius = 44
	var count = 32

	for i in range(count):
		var rotRad = 2*PI*i/count
		var spawnPos = Vector2(radius, 0).rotated(rotRad)
		var sparkSpot = sparkSpotScn.instance()
		sparkSpot.position = spawnPos
		sparkSpot.rotation_degrees = rad2deg(rotRad) - 90
		add_child(sparkSpot)
