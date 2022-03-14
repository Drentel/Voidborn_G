extends Node
class_name MapEvent

onready var root_node = find_root_node()

func find_root_node(node = self):
	if ("IS_MAP_NODE" in node):
		return node
	else:
		return find_root_node(node.get_parent())

func activate():
	for i in get_children():
		i.activate()

func activate_num(num):
	if get_child_count() > num:
		get_child(num).activate()
