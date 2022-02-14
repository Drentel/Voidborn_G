extends BaseStatus

var stacks = 0

func _init():
	status_name = "KEN"

func _ready():
	status_owner.connect("turn_end", self, "on_turn_end")
	status_owner.connect("critted", self, "on_critted")

func get_desc():
	return "KEN\nCTD increased by " + str(ceil(stacks*status_owner.get_base_stat_val("CTD")*0.1)) + ". This buff increases by 0.1x base CTD when character crits, but reduced by 0.1x base CTD when their turn ends."

func handle_dupe(dupe):
	pass

func on_turn_end():
	if stacks > 0:
		stacks -= 1
		upd()

func on_critted(_inst):
	stacks += 1
	upd()

func upd():
	GUtil.annihilate_children(self)
	if stacks > 0:
		var nod = Influencer.new()
		nod.target_stat = "CTD"
		nod.influence = ceil(stacks*status_owner.get_base_stat_val("CTD")*0.1)
		add_child(nod)
