extends ScrollContainer


func _ready():
	pass

func clear(_node):
	GUtil.annihilate_children($ItemList)

func handle_buttons(buttons):
	for i in buttons:
		i.size_flags_horizontal += Button.SIZE_EXPAND
		$ItemList.add_child(i)
