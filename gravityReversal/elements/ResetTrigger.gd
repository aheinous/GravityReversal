extends Area2D

func _ready():
	pass


func _on_ResetTrigger_area_entered(area):
	print('_on_ResetTrigger_area_entered(', area, ')')
	if area.is_in_group('player'):
		get_tree().call_group('resettable', 'reset')
