extends BaseStatus
class_name BaseArtiStatus

var lvl = 1

func _init():
	status_name = "REG"

func _ready():
	status_owner.connect("turn_start", self, "on_turn_start")

func get_desc():
	return "REG\nHeals for " + str(round(GUtil.teddy(lvl)*100)/100.0) + "x MHP at the start of turn"

# This ususally will not be called for statuses that are inflicted by artifact passives
func handle_dupe(dupe):
	lvl = max(dupe.lvl, lvl)

func on_turn_start():
	var dmg = DamageInstance.new()
	dmg.sender = status_owner
	dmg.target = status_owner
	dmg.amount = ceil(GUtil.teddy(lvl)*status_owner.get_stat_val("MHP"))
	dmg.pierce = 1.0
	dmg.is_homing = true
	dmg.is_able_crit = false
	dmg.dmg_type = dmg.TYPE.HEAL
	Curtain.ln("Regeneration activates")
	status_owner.send_dmg(dmg)
