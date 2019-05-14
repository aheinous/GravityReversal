extends TileMap


const explosionScene = preload('res://elements/Explosion.tscn')



func _ready():
	pass


func onPlayerHit(player, collision):

	var tilePos = world_to_map(collision.position - collision.normal*(cell_size/2))
	var celln = get_cellv(tilePos)
	if celln == -1:
		return false
	set_cellv(tilePos, -1)
#	update_dirty_quadrants()
	print('bomb hit by player: ', collision, ', ', tilePos, ', ', celln)

	var explosion = explosionScene.instance()
	explosion.position = map_to_world(tilePos) + cell_size / 2
	get_tree().get_current_scene().add_child(explosion)
	return true













	# print('tilePos: ', tilePos)
	# print('normal: ', collision.normal)
