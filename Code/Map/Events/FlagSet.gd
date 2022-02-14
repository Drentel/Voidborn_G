extends MapEvent

export var flag: String
export var use_string = false
export var bool_val = false
export var str_val: String

func activate():
	if use_string:
		GPlayer.flags[flag] = str_val
	else:
		GPlayer.flags[flag] = bool_val
	
	.activate()
