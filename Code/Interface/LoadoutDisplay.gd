extends Label

func upd():
	text = load(get_parent().soul).shortname

func _ready():
	get_parent().connect("unpacked", self, "upd")
