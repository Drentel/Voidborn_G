extends BaseWeaponSkill

func _init():
	item_base_name = "Claymore"
	possible_stats = ["ATK", "DEF"]

	s_name = "Claymore attack"
	s_desc = "Deals 0.4xATK+0.4xDEF damage to target. Ignores 40% of target DEF"

func show_desc_tip(owner):
	Tip.set_disp(["Deals " + GUtil.wrap_highlight(ceil((owner.get_base_stat_val("ATK")*0.4)+(owner.get_base_stat_val("DEF")*0.4))) + " damage to target. Ignores 40% of target DEF"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.sender = user
		inst.target = target
		inst.amount = (user.get_stat_val("ATK")*0.4)+(user.get_stat_val("DEF")*0.4)
		inst.pierce = 0.4
		SFXR.frame_sfx("claymore", inst.target.get_global_rect(), Color.lightblue, true, false)
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
