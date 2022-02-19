extends BaseWeaponSkill

func _init():
	item_base_name = "Rapier"
	possible_stats = ["ATK", "SPD"]

	s_name = "Rapier attack"
	s_desc = "Deals 0.5xATK damage to target, with a 40% chance to attack again"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "Deals " + str(0.5 + level*0.025) + "xATK damage to target, with a " + str(40 + ceil(GUtil.teddy(level*3)*60)) + "% chance to attack again"

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		while true:
			yield(get_tree(), "idle_frame")
			if !is_instance_valid(target): # This is in case the initial target dies
				if c_manager.get_enemies().size() > 0:
					target = GUtil.arr_rand(c_manager.get_enemies())
				else:
					break
			var inst = DamageInstance.new()
			inst.dmg_type = DamageInstance.TYPE.PHYS
			inst.sender = user
			inst.target = target
			inst.amount = user.get_stat_val("ATK")*(0.5+(level*0.025))
			SFXR.frame_sfx("rapier", inst.target.get_global_rect(), Color.wheat, false, false, false)
			yield(get_tree().create_timer(0.15), "timeout")
			$"/root/Root".screen_shake(0.1)
			user.send_dmg(inst)
			
			if randi()%100 > (40+ceil(GUtil.teddy(level*3)*60)):
				break
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
