extends Area2D

func _on_CheckPoint_area_entered(area):
	CheckpointSys.playerReachedCheckpoint(self.position, self.get_path())
