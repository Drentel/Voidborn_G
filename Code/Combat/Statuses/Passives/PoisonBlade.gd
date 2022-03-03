extends BaseStatus

func _init():
	status_name = "PSB"

func _ready():
	status_owner.connect("sent_dmg", self, "sent_dmg")

func get_desc():
	return "PSB\nCritical hits poison for 0.4xTEC"

func handle_dupe(dupe):
	pass

func sent_dmg(inst):
	if inst.did_crit && !inst.dmg_type == DamageInstance.TYPE.HEAL && inst.target != inst.sender:
		inst.connect("dmg_applied", self, "dmg_dealt", [inst])

func dmg_dealt(inst):
	var nod = Node.new()
	nod.set_script(preload("res://Code/Combat/Statuses/PoisonStatus.gd"))
	nod.stacks = ceil(status_owner.get_stat_val("TEC"))
	inst.target.apply_status(nod)

