extends BaseStatus

var stacks: int

func _init():
	status_name = "PSN"

func _ready():
	status_owner.connect("turn_end", self, "on_turn_end")

func get_desc():
	return "PSN\nDeals " + str(stacks) + " unavoidable fully-piercing damage at the end of the turn. Damage is halved after each application"

func handle_dupe(dupe):
	stacks += dupe.stacks

func on_turn_end():
	var dmg = DamageInstance.new()
	Curtain.ln("Poison deals %s damage" % [stacks])
	dmg.sender = status_owner
	dmg.target = status_owner
	dmg.amount = stacks
	dmg.pierce = 1.0
	dmg.is_homing = true
	dmg.is_able_crit = false
	dmg.dmg_type = dmg.TYPE.PHYS
	
	status_owner.send_dmg(dmg)
	
	stacks /= 2
	
	if stacks < 1:
		get_parent().remove_child(self)
		queue_free()
