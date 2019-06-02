extends Node

func _ready():
	pass



var curSong = null

func setSong(scn):
#	print('set song: ', scn)
#	if path == curSong:
#		print(' ... song already playing')
#		return
#	curSong = path
#	if path == null:
#		self.stop()
#		return
#	print('... starting song')
#	self.stream = load(path)
#	self.play()


	if curSong == scn:
#		print('... song already playing -> rtn')
		return

	curSong = scn

	while self.get_child_count() >= 1:
		var child = self.get_child(0)
		self.remove_child(child)
#		print('... rmving child: ', child)
		child.queue_free()


	if curSong == null:
#		print('... cur song null -> silence')
		return

#	print('child cnt: ', self.get_child_count())

	var songNode = scn.instance()
#	print('... playing ', songNode)
	self.add_child(songNode)
	songNode.play()
#	print('child cnt: ', self.get_child_count())
