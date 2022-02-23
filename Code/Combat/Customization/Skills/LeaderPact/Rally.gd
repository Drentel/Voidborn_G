extends BaseSkill

func check_usability(unit):
	return unit.get_manager().get_living_allies().size() > 1

func _init():
	s_name = "Rally"
	s_desc = """Cost: 25 MP\nBuffs SPD and AVD of all allies except self by 0.35x TEC"""

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 25 MP\nBuffs SPD and AVD of all allies except self by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("TEC")*0.35))])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(25)
	
	var targets = find_manager().get_living_allies()
	for i in targets:
		if i != user:
			var status = Node.new()
			status.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
			status.stacks = [
				{"stat": "SPD",
				"val": user.get_stat_val("TEC")*0.35,
				"duration": 3},
				{"stat": "AVD",
				"val": user.get_stat_val("TEC")*0.35,
				"duration": 3}
			]
			i.apply_status(status)
			for j in status.stacks:
				Curtain.ln("%s of %s is increased by %s for 3 turns" % [j["stat"], i.name, j["val"]])
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
