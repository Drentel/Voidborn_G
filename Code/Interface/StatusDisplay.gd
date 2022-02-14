extends ScrollContainer

func _ready():
	GUtil.annihilate_children($GridContainer)
	get_parent().connect("status_added", self, "add")
	get_parent().connect("status_removed", self, "rem")
	
	connect("mouse_entered", self, "status_tooltip")
	connect("mouse_exited", Tip, "hide")

func add(status):
	var lab = Label.new()
	lab.text = status.status_name
	lab.set_meta("status", status)
	$GridContainer.add_child(lab)

func rem(status):
	for i in $GridContainer.get_children():
		if i.get_meta("status") == status:
			$GridContainer.remove_child(i)

func status_tooltip():
	var descs = []
	for i in get_parent().get_statuses():
		descs.append(i.get_desc())
	
	if descs != []:
		Tip.set_disp(descs)
