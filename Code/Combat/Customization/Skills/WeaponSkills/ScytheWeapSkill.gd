extends BaseWeaponSkill

func _init():
	item_base_name = "Scythe"
	possible_stats = ["CTD", "CTR"]

	s_name = "Scythe attack"
	s_desc = "Deals 0.8xATK damage to one target, with a 10% chance to attack all enemies afterwards"

func show_desc_tip(owner):
	Tip.set_disp(["Deals [color=#0FF]" + str(ceil(owner.get_base_stat_val("ATK")*(0.8+(level*0.04)))) + "[/color] damage to target, with a 10% chance to attack all enemies afterwards"])

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "Deals %sxATK damage to one target, with a 10%% chance to attack all enemies afterwards"
	s_desc = s_desc % [(0.8+(level*0.04))]

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		var dmg = DamageInstance.new()
		dmg.dmg_type = DamageInstance.TYPE.PHYS
		dmg.is_homing = false
		dmg.pierce = 0.0
		dmg.sender = user
		dmg.target = target
		dmg.amount = user.get_stat_val("ATK")*(0.8+(level*0.04))
		SFXR.frame_sfx("claymore", dmg.target.get_global_rect(), Color.red)
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(dmg)
		
		if randi()%10 == 0:
			Curtain.ln("The scythe sings!")
			# Get targets again in case someone died
			targets = c_manager.get_enemies()
			for i in targets:
				var inst = DamageInstance.new()
				inst.dmg_type = DamageInstance.TYPE.PHYS
				inst.sender = user
				inst.target = i
				inst.amount = user.get_stat_val("ATK")*(0.8+(level*0.08))
				SFXR.frame_sfx("claymore", inst.target.get_global_rect(), Color.red, false, false, false)
				yield(get_tree().create_timer(0.2), "timeout")
				$"/root/Root".screen_shake(0.1)
				user.send_dmg(inst)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
