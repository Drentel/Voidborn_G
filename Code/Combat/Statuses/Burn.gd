extends BaseStatus

var stacks: int

func _init():
	status_name = "BUR"

func _ready():
	status_owner.connect("received_dmg", self, "on_received_dmg")
	
	if stacks < 1:
		get_parent().remove_child(self)
		queue_free()

func get_desc():
	return "BUR\nAbsorbs up to " + str(stacks) + " healing instead of HP"

func handle_dupe(dupe):
	stacks += dupe.stacks

func on_received_dmg(inst):
	if inst.dmg_type != DamageInstance.TYPE.HEAL:
		return
	
	var original_amount = inst.amount
	inst.amount -= stacks
	
	if inst.amount < 0:
		stacks = abs(inst.amount)
		inst.amount = 0
	else:
		stacks = 0
	
	Curtain.ln("Burn reduced incoming healing from %s to %s (%s burn left)" % [original_amount, inst.amount, stacks])
	
	if stacks < 1:
		get_parent().remove_child(self)
		queue_free()
