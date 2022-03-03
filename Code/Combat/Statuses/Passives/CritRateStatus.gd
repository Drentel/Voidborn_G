extends BaseStatus

var stacks = 0

func _init():
	status_name = "FOC"

func _ready():
	status_owner.connect("turn_start", self, "turn_start")
	status_owner.connect("status_removed", self, "status_removed")

func get_desc():
	return """FOC
Crit rate (CTR) increased by """ + str(stacks) + ". This bonus is increased by 10 when character starts the turn, but reset when a crit turn ends"

func turn_start():
	stacks += 10
	GUtil.annihilate_children(self)
	var inf = Influencer.new()
	inf.target_stat = "CTR"
	inf.influence = stacks
	add_child(inf)

func status_removed(status):
	if status is CriticalStatus:
		stacks = 0
		GUtil.annihilate_children(self)
