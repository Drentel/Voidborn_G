extends BaseSkill

func _init():
	s_name = "Barrier Blade"
	s_desc = "Cost: 35 MP\nDeals 2xDEF magic dmg to one target, and grants barrier equal to 3xDEF"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 35 MP\nDeals " + GUtil.wrap_highlight(ceil(owner.get_stat_val("DEF")*2)) + " magic dmg to one target, and grants " + GUtil.wrap_highlight(ceil(owner.get_stat_val("DEF")*3)) + " barrier"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(35)
		
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.MAG
		inst.sender = user
		inst.target = target
		inst.amount = user.get_stat_val("DEF")*2
		SFXR.frame_sfx("ice", target.get_global_rect(), Color.orange, true, false, true)
		SFXR.frame_sfx("shield", user.get_global_rect(), Color.orange, false, false, true)
		yield(get_tree().create_timer(0.3), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		
		var nod = Node.new()
		nod.set_script(load("res://Code/Combat/Statuses/Barrier.gd"))
		nod.stacks = user.get_stat_val("DEF")*3
		Curtain.ln("%s gains %s barrier" % [user.name, user.get_stat_val("DEF")*3])
		user.apply_status(nod)
		
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
