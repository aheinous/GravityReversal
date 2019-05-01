extends TileMap


const explosionScene = preload('res://elements/Explosion.tscn')



func _ready():
	pass


func onPlayerHit(player, collision):
	# print('bomb hit by player: ', collision)

	var tilePos = world_to_map(player.position) - collision.normal.round()
	set_cellv(tilePos, -1)

	var explosion = explosionScene.instance()
	explosion.position = map_to_world(tilePos) + cell_size / 2
	get_tree().get_current_scene().add_child(explosion)













	# print('tilePos: ', tilePos)
	# print('normal: ', collision.normal)
