extends BaseSkill

func _init():
	s_name = "Shadowstrike"
	s_desc = "Cost: 15 MP\nDeals 0.5xATK damage to single target. Damage is multiplied 4x if this attack crits."

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(15)
		
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.sender = user
		inst.target = target
		inst.amount = user.get_stat_val("ATK")*0.5
		SFXR.frame_sfx("claymore", target.get_global_rect(), Color.red, true)
		yield(get_tree().create_timer(0.3), "timeout")
		$"/root/Root".screen_shake(0.1)
		inst.connect("pre_dmg_adjusted", self, "on_instance_crit", [inst])
		user.send_dmg(inst)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)

func on_instance_crit(inst: DamageInstance):
	if inst.did_crit:
		Curtain.ln("Shadowstrike! Damage is multiplied by 4")
		inst.amount *= 4
