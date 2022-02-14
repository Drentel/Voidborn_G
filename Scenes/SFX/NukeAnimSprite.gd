extends AnimatedSprite


func _ready():
	playing = true
	connect("animation_finished", self, "nuke")

func nuke():
	get_parent().remove_child(self)
	queue_free()
