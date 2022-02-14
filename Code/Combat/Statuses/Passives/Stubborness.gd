extends BaseStatus

func _init():
	status_name = "STB"

func _ready():
	status_owner.connect("pre_applied_dmg", self, "on_pre_applied_dmg")

func get_desc():
	return """STB
Survive fatal DMG with 1 HP. Status is removed after activation"""

func on_pre_applied_dmg(inst):
	if inst.dmg_type != DamageInstance.TYPE.HEAL and inst.amount >= status_owner.hp:
		Curtain.ln("Stubborness activates! Fatal DMG survived with 1 HP")
		inst.amount = status_owner.hp - 1
		get_parent().remove_child(self)
		queue_free()
