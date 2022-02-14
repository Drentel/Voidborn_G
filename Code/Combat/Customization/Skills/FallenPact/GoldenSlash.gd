extends BaseSkill

func _init():
	s_name = "Golden slash"
	s_desc = "Cost: All MP\nDeals 1xATK damage to single target. Damage is increased by 0.1x for every point of MP spent to cast this skill. Never triggers an overcast. Homing."

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		var spent_mp = user.mp
		Curtain.ln("%s uses %s (%s mana spent for %s total multiplier)" % [user.name, s_name, spent_mp, (1+spent_mp*0.1)])
		user.spend_mp(user.mp)
		
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.sender = user
		inst.target = target
		inst.is_homing = true
		inst.amount = ceil(user.get_stat_val("ATK")*(1+spent_mp*0.1))
		SFXR.frame_sfx("bigslash", target.get_global_rect(), Color.gold)
		yield(get_tree().create_timer(0.5), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
