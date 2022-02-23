extends BaseSkill

func check_usability(unit):
	return unit.get_manager().get_living_allies().size() > 1

func _init():
	s_name = "Transfer"
	s_desc = """Cost: 0.5xMMP\nTransfers half of MMP to target ally. Will not consume more MP than the target can hold"""

func show_desc_tip(owner):
	Tip.set_disp(["Cost: " + GUtil.wrap_highlight(ceil(owner.get_stat_val("MMP")*0.5)) + " MP\nTransfers half of MMP to target ally. Will not consume more MP than the target can hold"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_living_allies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		var transfer = user.get_stat_val("MMP")/2
		transfer = min(transfer, target.get_stat_val("MMP") - target.mp)
		Curtain.ln(user.name + " transfers " + str(transfer) + " MP to " + target.name)
		user.spend_mp(transfer)
		target.mp_set(transfer + target.mp)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
