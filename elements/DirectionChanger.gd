extends Area2D

func _ready():
	pass


func _on_DirectionChanger_body_entered(body):
	print("_on_DirectionChanger_body_entered(%s)" % body)
