extends Node
class_name MoveOverrideEvent

export var flags = []
export var any_one = false

func activate():
	var pas
	
	if any_one:
		pas = false
		for i in flags:
			if GPlayer.flags.has(i) && GPlayer.flags[i] == true:
				pas = true
				break
	else:
		pas = true
		for i in flags:
			if !GPlayer.flags.has(i):
				pas = false
				break
			elif GPlayer.flags[i] == false:
				pas = false
				break
	
	if pas:
		return true
	else:
		for i in get_children():
			if i is MapEvent:
				i.activate()
		return false
