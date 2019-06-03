extends CenterContainer

func _process(delta):
	var screenWidth = get_viewport_rect().size.x
	self.rect_size.x = screenWidth