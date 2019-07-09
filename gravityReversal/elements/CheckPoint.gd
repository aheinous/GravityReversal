extends Area2D

export var upsideDown:bool = false

func _on_CheckPoint_area_entered(area):
	CheckpointSys.playerReachedCheckpoint(self.position, self.get_path(), Global.getPlayer().angleDegrees, upsideDown)
