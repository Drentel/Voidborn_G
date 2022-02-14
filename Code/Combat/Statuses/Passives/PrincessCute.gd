extends BaseStatus

func _init():
	status_name = "CYU"

func _ready():
	status_owner.connect("applied_dmg", self, "applied_dmg")

func get_desc():
	return "CYU\nHalf of received damage is added to all allies except self as fury"

func handle_dupe(dupe):
	pass

func applied_dmg(inst):
	if inst.amount > 0 && inst.dmg_type != DamageInstance.TYPE.HEAL:
		Curtain.ln("Cute activates")
		for i in status_owner.get_manager().get_living_allies():
			if i != status_owner:
				var nod = Node.new()
				nod.set_script(preload("res://Code/Combat/Statuses/Rage.gd"))
				nod.stacks = inst.amount/2
				Curtain.ln(i.name + " gains " + str(inst.amount/2) + " rage")
				i.apply_status(nod)
