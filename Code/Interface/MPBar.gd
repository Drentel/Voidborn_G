extends ProgressBar


func _ready():
	yield(get_tree(), "idle_frame") # Make sure parent is ready
	get_parent().connect("mp_changed", self, "upd")
	upd()

func upd(_mp = 0, _new = 0):
	max_value = get_parent().get_stat_val("MMP")
	value = get_parent().mp_get()
