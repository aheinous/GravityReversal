extends TileMap

const explosionScene = preload('res://elements/Explosion.tscn')

func onPlayerHit(player, collision):

	var tilePos = world_to_map(collision.position - collision.normal*(cell_size/2))
	var celln = get_cellv(tilePos)
#	var tryNum = 0

	if celln == -1:
		tilePos = world_to_map(collision.position - collision.normal.rotated(deg2rad(10))*(cell_size/2))
		celln = get_cellv(tilePos)
#		tryNum = 1

	if celln == -1:
		tilePos = world_to_map(collision.position - collision.normal.rotated(deg2rad(-10))*(cell_size/2))
		celln = get_cellv(tilePos)
#		tryNum = 2

#	print('Bomb Hit: %s %s %s, %s, %d' % [tilePos, collision.position, collision.normal, celln, tryNum])

	if celln == -1:
		print('false bomb hit')
		return false

	set_cellv(tilePos, -1)

	var explosion = explosionScene.instance()
	explosion.position = map_to_world(tilePos) + cell_size / 2
	get_tree().get_current_scene().add_child(explosion)
	return true
