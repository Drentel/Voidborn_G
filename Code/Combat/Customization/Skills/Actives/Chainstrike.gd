extends BaseSkill

func _init():
	s_name = "Chainstrike"
	s_desc = "Cost: 20 MP\nDeals 1.5xATK damage, and buffs ATK and DEF by 0.2x ATK for 5 turns"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 20 MP\nDeals " + GUtil.wrap_highlight(ceil(owner.get_stat_val("ATK")*1.5)) + " damage, and buffs ATK and DEF by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("ATK")*0.2)) + " for 5 turns"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(60)

		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.sender = user
		inst.target = target
		inst.amount = user.get_stat_val("ATK")*1.5
		SFXR.frame_sfx("sword", inst.target.get_global_rect(), Color.goldenrod)
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		
		var status = Node.new()
		status.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
		status.stacks = [
			{"stat": "DEF",
			"val": user.get_stat_val("ATK")*0.2,
			"duration": 6},
			{"stat": "ATK",
			"val": user.get_stat_val("ATK")*0.2,
			"duration": 6}
		]
			
		for i in status.stacks:
			Curtain.ln("%s of %s is increased by %s for 5 turns" % [i["stat"], user.name, i["val"]])
		
		user.apply_status(status)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
