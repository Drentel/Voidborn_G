extends BaseSkill

func _init():
	s_name = "Steal"
	s_desc = "Cost: 25 MP\nOne of the enemy's target stats is reduced by 40%, and the user gains an equivalent increase in the same stat. Target stat is random, but higher stats will be stolen more often."

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(25)
		SFXR.frame_sfx("smoke", target.get_global_rect())
		var stats = WeightedPool.new()
		
		for i in GUtil.stat_definitions:
			if not i in ["MMP", "MHP"]: 
				stats.add(i, target.get_base_stat_val(i))
		
		var stn = stats.pick()
		var stv = target.get_base_stat_val(stn)
		
		var stat_nod = Node.new()
		stat_nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
		stat_nod.stacks.append({"stat":stn, "val":ceil(stv*0.4), "duration":4})
		Curtain.ln("%s's %s is increased by %s for 3 turns" % [user.name, stn, ceil(stv*0.4)])
		user.apply_status(stat_nod)
		
		var enemy_stat_nod = Node.new()
		enemy_stat_nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
		enemy_stat_nod.stacks.append({"stat":stn, "val":ceil(stv*-0.4), "duration":3})
		Curtain.ln("%s's %s is reduced by %s for 3 turns" % [target.name, stn, ceil(stv*-0.4)])
		target.apply_status(enemy_stat_nod)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
