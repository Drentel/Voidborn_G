extends AnimationPlayer


func _ready():
	connect("animation_finished", self, "nuke")

func nuke(_arg):
	get_parent().get_parent().remove_child(get_parent())
	get_parent().queue_free()
