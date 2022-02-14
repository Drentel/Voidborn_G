extends BaseStatus

func _init():
	status_name = "DEV"

func _ready():
	for i in status_owner.get_manager().get_allies():
		if i != status_owner:
			i.connect("applied_dmg", self, "applied_dmg")

func get_desc():
	return "DEV\nGain 0.5x damage received by other allies as fury."

func handle_dupe(dupe):
	pass

func applied_dmg(inst):
	if inst.amount > 0 && inst.dmg_type != DamageInstance.TYPE.HEAL:
		Curtain.ln("Devotion activates!")
		var nod = Node.new()
		nod.set_script(preload("res://Code/Combat/Statuses/Rage.gd"))
		nod.stacks = inst.amount/2
		Curtain.ln(status_owner.name + " gains " + str(inst.amount/2) + " rage")
		status_owner.apply_status(nod)
