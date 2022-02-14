extends BaseStatus

var stacks = 0

func _init():
	status_name = "SIP"

func _ready():
	status_owner.connect("received_dmg", self, "received_dmg")

func get_desc():
	return "SIP\nAVD increased by " + str(ceil(stacks*status_owner.get_base_stat_val("AVD")*0.1)) + ". This buff increases by 0.1x base AVD when character is hit."

func handle_dupe(dupe):
	pass

func upd():
	GUtil.annihilate_children(self)
	if stacks > 0:
		var nod = Influencer.new()
		nod.target_stat = "AVD"
		nod.influence = ceil(stacks*status_owner.get_base_stat_val("AVD")*0.1)
		add_child(nod)

func received_dmg(_garbage):
	stacks += 1
	upd()
