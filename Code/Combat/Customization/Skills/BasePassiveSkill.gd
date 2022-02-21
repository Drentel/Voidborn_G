extends Node
class_name BasePassiveSkill

var s_name = "Base passive skill"
var s_desc = "Does literally nothing"

func show_desc_tip(owner = ""):
	if "IS_UNIT" in owner:
		Tip.set_disp([s_desc + "\nDEBUG: UNIT IS " + owner.name])

func find_user(nod = self):
	# This is stupid but i see no other way to avoid cyclic references
	if ("IS_UNIT" in nod):
		return nod
	else:
		return find_user(nod.get_parent())

func start_combat():
	pass

func _ready():
	find_user().connect("entered_combat", self, "start_combat")
