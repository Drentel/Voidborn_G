extends VBoxContainer


func _ready():
	GUtil.annihilate_children(self)
	for i in GUtil.stat_definitions:
		var st = Label.new()
		st.text = i
		add_child(st)
		st.mouse_filter = Label.MOUSE_FILTER_PASS
		st.connect("mouse_entered", Tip, "set_disp", [[GUtil.stat_definitions[i]]])
		st.connect("mouse_exited", Tip, "hide")
		st.connect("tree_exited", Tip, "hide")
