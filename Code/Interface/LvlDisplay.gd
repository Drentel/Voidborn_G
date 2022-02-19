extends Label

func upd():
	text = "LV " + str(get_parent().lvl) + " "

func _ready():
	get_parent().connect("unpacked", self, "upd")
