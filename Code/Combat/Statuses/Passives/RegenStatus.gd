extends BaseStatus

func _init():
	status_name = "REG"

func _ready():
	status_owner.connect("turn_start", self, "on_turn_start")

func get_desc():
	return "REG\nHeals for " + GUtil.wrap_highlight(status_owner.get_stat_val("MHP")*0.15) + "xMHP at the start of turn"

func on_turn_start():
	var dmg = DamageInstance.new()
	dmg.sender = status_owner
	dmg.target = status_owner
	dmg.amount = ceil(0.15*status_owner.get_stat_val("MHP"))
	dmg.pierce = 1.0
	dmg.is_homing = true
	dmg.is_able_crit = false
	dmg.dmg_type = dmg.TYPE.HEAL
	Curtain.ln("Regeneration activates")
	status_owner.send_dmg(dmg)
