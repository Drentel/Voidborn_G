extends MapEvent

export var prob = 20

func activate():
	var ran = randi()%100
	if ran < prob:
		GUtil.arr_rand(get_children()).activate()
