extends Label

func _ready():
	get_parent().connect("renamed", self, "on_rename")
	on_rename()

func on_rename():
	text = get_parent().name
