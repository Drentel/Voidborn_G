extends BaseStatus
class_name CriticalStatus

func _init():
	status_name = "CRIT"

func _ready():
	status_owner.connect("sent_dmg_priority", self, "on_sent_dmg")
	status_owner.connect("turn_end", self, "on_turn_end")
	SFXR.frame_sfx("swordup", status_owner.get_global_rect(), Color.gold)

func get_desc():
	return "CRIT\nAttacks deal " + GUtil.wrap_highlight(1+(status_owner.get_stat_val("CTD")/100.0)) + "x damage until end of turn"

func on_sent_dmg(priority, inst):
	if priority == 0:
		if is_instance_valid(self) and get_parent() != null:
			if inst.is_able_crit:
				inst.amount *= (status_owner.get_stat_val("CTD")/100.0)+1
				inst.did_crit = true
				Curtain.ln("Crit!")
				status_owner.emit_signal("critted", inst)

func on_turn_end():
	get_parent().remove_child(self)
	queue_free()
