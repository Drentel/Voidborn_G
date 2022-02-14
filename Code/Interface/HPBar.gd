extends ProgressBar


func _ready():
	yield(get_tree(), "idle_frame") # Make sure parent is ready
	get_parent().connect("hp_changed", self, "upd")
	upd()

func upd(_hp = 0, _new = 0):
	max_value = get_parent().get_stat_val("MHP")
	value = get_parent().hp_get()
