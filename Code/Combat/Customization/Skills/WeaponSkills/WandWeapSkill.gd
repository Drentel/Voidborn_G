extends BaseWeaponSkill

func _init():
	item_base_name = "Wand"
	possible_stats = ["CRM", "MMP"]
	
	s_name = "Wand attack"
	s_desc = "Deals 0.8xCRM homing magic damage to target"

func show_desc_tip(owner):
	Tip.set_disp(["Deals " + GUtil.wrap_highlight(ceil(owner.get_base_stat_val("CRM")*(0.8 + level*0.04))) + " homing magic damage to target"])

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "Deals " + str(0.8 + level*0.04) + "xCRM homing magic damage to target"

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.MAG
		inst.sender = user
		inst.target = target
		inst.is_homing = true
		inst.amount = user.get_stat_val("CRM")*(0.8+(level*0.04))
		SFXR.frame_sfx("star", inst.target.get_global_rect())
		yield(get_tree().create_timer(0.15), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
