extends BaseStatus

func _init():
	status_name = "LSS"

func _ready():
	status_owner.connect("sent_dmg", self, "on_sent_dmg")

func get_desc():
	return """LSS
Damage is increased by 1x for every dead ally. Current multiplier: """ + str(status_owner.get_manager().get_allies().size() - status_owner.get_manager().get_living_allies().size() + 1) + "x"

func on_sent_dmg(inst):
	var mult = status_owner.get_manager().get_allies().size() - status_owner.get_manager().get_living_allies().size() + 1
	if mult > 1:
		Curtain.ln("%s multiplied damage by %s" % ["Last stand", mult])
		inst.amount *= mult
