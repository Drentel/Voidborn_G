extends Label

func _ready():
	yield(get_tree(), "idle_frame") # Make sure parent is ready
	get_parent().connect("changed", self, "_upd")
	get_parent().connect("value_changed", self, "_upd")
	_upd()

func _upd(_val = 0):
	text = str(get_parent().value) + "/" + str(get_parent().max_value)
