extends Label

func upd():
	text = load(get_parent().soul).shortname
	text += "/"
	text += load(get_parent().pact).shortname

func _ready():
	get_parent().connect("unpacked", self, "upd")
