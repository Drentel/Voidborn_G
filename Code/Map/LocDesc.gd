extends Panel

func desc(node):
	$ScrollContainer/Label.text = node.get_desc()

func _ready():
	pass
