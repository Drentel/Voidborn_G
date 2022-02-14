extends BaseStatus

var stacks: int

func _init():
	status_name = "BAR"

func _ready():
	status_owner.connect("received_dmg", self, "on_received_dmg")
	
	if stacks < 1:
		get_parent().remove_child(self)
		queue_free()

func get_desc():
	return "BAR\nBlocks up to " + str(stacks) + " damage in place of HP. Not influenced by DEF or AUR, and attacks that fully ignore defense come right through"

func handle_dupe(dupe):
	stacks += dupe.stacks

func on_received_dmg(inst):
	if inst.pierce == 1.0:
		return
	
	var original_amount = inst.amount
	inst.amount -= stacks
	
	if inst.amount < 0:
		stacks = abs(inst.amount)
		inst.amount = 0
	else:
		stacks = 0
	
	Curtain.ln("Barrier reduced incoming damage from %s to %s (%s barrier left)" % [original_amount, inst.amount, stacks])
	
	if stacks < 1:
		get_parent().remove_child(self)
		queue_free()
