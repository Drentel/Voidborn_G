extends BaseStatus

func _init():
	status_name = "SUP"

func _ready():
	for i in status_owner.get_manager().get_allies():
		if i != status_owner:
			i.connect("sent_dmg", self, "on_sent_dmg")

func get_desc():
	if status_owner.dead:
		return "SUP\nAll allies except self deal 0.8x damage with their attacks."
	else:
		return "SUP\nAll allies except self deal 1.2x damage with their attacks."

func handle_dupe(dupe):
	pass

func on_sent_dmg(inst):
	if inst.amount > 0 && inst.dmg_type != DamageInstance.TYPE.HEAL:
		if status_owner.dead:
			Curtain.ln("Moral support multiplies damage by 0.8x")
			inst.amount = ceil(inst.amount*0.8)
		else:
			Curtain.ln("Moral support multiplies damage by 1.2x")
			inst.amount = ceil(inst.amount*1.2)
