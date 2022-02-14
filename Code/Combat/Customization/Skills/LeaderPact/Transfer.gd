extends BaseSkill

func check_usability(unit):
	return unit.get_manager().get_living_allies().size() > 1

func _init():
	s_name = "Transfer"
	s_desc = """Cost: 1/2 MP\nTransfers half of MMP to target ally. Will not consume more MP than necessary."""

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_living_allies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		var transfer = user.get_stat_val("MMP")/2
		transfer = min(transfer, target.get_stat_val("MMP") - target.mp)
		Curtain.ln(user.name + " transfers" + str(transfer) + " MP to " + target.name)
		user.spend_mp(transfer)
		target.mp_set(transfer + target.mp)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
