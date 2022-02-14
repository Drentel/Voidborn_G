extends MapEvent

export var flag: String
export var activate_if: bool

func activate():
	var act = false
	
	if GPlayer.flags.has(flag):
		if GPlayer.flags[flag] == activate_if:
			act = true
		else:
			act = false
	else:
		act = !activate_if
	
	if act:
		if get_child_count() > 0:
			get_child(0).activate()
	else:
		if get_child_count() > 1:
			get_child(1).activate()
