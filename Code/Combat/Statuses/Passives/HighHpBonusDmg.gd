extends BaseStatus

func _init():
	status_name = "GSR"

func _ready():
	status_owner.connect("sent_dmg", self, "on_sent_dmg")

func get_desc():
	return """GSR
Deal 1.2x damage to creatures that have more HP than you"""

func on_sent_dmg(inst):
	if inst.sender == status_owner and inst.target.hp > inst.sender.hp:
		inst.amount *= 1.2
