extends BaseStatus

var cd = false

func _init():
	status_name = "HRG"

func _ready():
	status_owner.connect("sent_dmg", self, "sent_dmg")
	status_owner.connect("turn_start", self, "turn_start")

func get_desc():
	if cd == false:
		return "HRG\nNext attack will heal ally with lowest HP%"
	else:
		return "HRG\nHit geneneration is on cooldown"

func handle_dupe(dupe):
	pass

func sent_dmg(inst):
	inst.connect("dmg_applied", self, "dmg_dealt", [inst])

func dmg_dealt(inst):
	if inst.dmg_type != DamageInstance.TYPE.HEAL && inst.amount > 0 && cd == false:
		var dmg = DamageInstance.new()
		dmg.dmg_type = DamageInstance.TYPE.HEAL
		if "BAR" in status_owner.get_status_names():
			dmg.amount = inst.amount
			Curtain.ln("Splitting care activates at full efficiency!")
		else:
			dmg.amount = inst.amount/2
			Curtain.ln("Splitting care activates at half efficiency (no barrier)")
		dmg.sender = status_owner
		dmg.target = $"/root/Root".get_living_characters()[0]
		for i in $"/root/Root".get_living_characters():
			if float(i.hp)/i.get_stat_val("MHP") < float(dmg.target.hp)/dmg.target.get_stat_val("MHP"):
				dmg.target = i
		if float(dmg.target.hp)/dmg.target.get_stat_val("MHP") == 1: # Targets a rando character if everyone is at full HP
			dmg.target = GUtil.arr_rand($"/root/Root".get_living_characters())
		
		dmg.pierce = 1
		dmg.is_homing = true
		dmg.is_able_crit = false
		
		status_owner.send_dmg(dmg)
		cd = true

func turn_start():
	cd = false
