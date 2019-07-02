extends TileMap

const explosionScene = preload('res://elements/Explosion.tscn')

func onPlayerHit(player, collision):
	var halfCellSize = scale * cell_size / 2

	var tilePos = world_to_map( (collision.position - collision.normal*halfCellSize) / scale )
	var celln = get_cellv(tilePos)
#	var tryNum = 0

	if celln == -1:
		tilePos = world_to_map( (collision.position - collision.normal.rotated(deg2rad(10))*halfCellSize) / scale )
		celln = get_cellv(tilePos)
#		tryNum = 1

	if celln == -1:
		tilePos = world_to_map( (collision.position - collision.normal.rotated(deg2rad(-10))*halfCellSize) / scale )
		celln = get_cellv(tilePos)
#		tryNum = 2

#	print('Bomb Hit: %s %s %s, %s, %d' % [tilePos, collision.position, collision.normal, celln, tryNum])

	if celln == -1:
		print('false bomb hit')
		return false

	set_cellv(tilePos, -1)

	var explosion = explosionScene.instance()
	explosion.position = map_to_world(tilePos)*scale + halfCellSize
	get_tree().get_current_scene().add_child(explosion)
	return true
