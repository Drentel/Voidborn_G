extends BaseStatus
class_name StatModStatus

var stacks = []

func _init():
	status_name = "STT"

func get_desc():
	var desc = "STT\n"
	
	for i in stacks:
		if i["val"] > 0:
			desc = desc + i["stat"] + " +" + str(ceil(i["val"])) + " :: " + str(i["duration"]) + " more turns\n"
		elif i["val"] < 0:
			desc = desc + i["stat"] + " " + str(ceil(i["val"])) + " :: " + str(i["duration"]) + " more turns\n"
	
	return desc

func handle_dupe(dupe):
	stacks += dupe.stacks
	upd()

func _ready():
	status_owner.connect("turn_end", self, "on_turn_end")

func on_turn_end():
	for i in stacks:
		i["duration"] -= 1
	
	clean()

func clean():
	var handled_stacks = []
	for i in stacks:
		if i["duration"] > 0:
			handled_stacks.append(i)
	stacks = handled_stacks
	upd()

func upd():
	GUtil.annihilate_children(self)
	
	if stacks == []:
		get_parent().remove_child(self)
		queue_free()
	else:
		for i in stacks:
			var inf = Influencer.new()
			inf.target_stat = i["stat"]
			inf.influence = ceil(i["val"])
			add_child(inf)
