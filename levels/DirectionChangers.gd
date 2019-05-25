extends TileMap


const dirChangePackedScene = preload('res://elements/DirectionChanger.tscn')

static func xyTransToDegrees(flipx, flipy, trans):
	if trans:
		return 90 if flipx else 270
	else:
		return 180 if flipx else 0


func _process(delta):
	switchTilesToDirChanges()
	set_process(false)


func switchTilesToDirChanges():
	for cellPos in get_used_cells():

		var worldPos = (map_to_world(cellPos) + cell_size/2)*self.scale

		var x = cellPos.x
		var y = cellPos.y
		var deg = xyTransToDegrees(is_cell_x_flipped(x,y), is_cell_y_flipped(x,y), is_cell_transposed(x,y))

		addDirChange(worldPos, deg)

		set_cellv(cellPos, -1)


func addDirChange(pos, deg):
	print('adding dir change at %s' % pos)
	var dirChange = dirChangePackedScene.instance()
	dirChange.position = pos
	dirChange.rotation_degrees = deg
	print(dirChange.position)
	get_tree().get_current_scene().add_child(dirChange)
