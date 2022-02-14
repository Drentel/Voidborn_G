extends Sprite

export var delay = 3.0

func _process(delta):
	if delay < 0 && !self.visible:
		self.visible = true
	else:
		delay -= delta
