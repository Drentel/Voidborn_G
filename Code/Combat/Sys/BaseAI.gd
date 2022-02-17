extends Node
class_name BaseAI

func _ready():
	get_parent().connect("turn_start", self, "act")

func act():
	yield(get_tree(), "idle_frame") # This one is here to make sure combat manager catches the turn_end signal
	GUtil.arr_rand(get_parent().get_skills()).use(get_parent())
