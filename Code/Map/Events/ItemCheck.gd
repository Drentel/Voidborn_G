extends MapEvent

export var item_name = "item name"
export var min_count = 1

func activate():
	if GPlayer.get_item(item_name) >= min_count:
		if get_child_count() > 0:
			get_children()[0].activate()
	elif get_child_count() > 1:
		get_children()[1].activate()
