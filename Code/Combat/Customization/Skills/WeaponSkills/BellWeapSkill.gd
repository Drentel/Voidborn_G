extends BaseWeaponSkill

func _init():
	item_base_name = "Bell"
	possible_stats = ["ATK", "CRM"]

	s_name = "Bell attack"
	s_desc = "Deals 0.2xATK+0.2xCRM damage to every enemy. Unavoidable"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "Deals " + str(0.2 + level*0.02) + "xATK+" + str(0.2 + level*0.01) + "xCRM damage to every enemy. Unavoidable"

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	
	for i in targets:
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.is_homing = true
		inst.sender = user
		inst.target = i
		inst.amount = user.get_stat_val("ATK")*(0.1+(level*0.005))+user.get_stat_val("CRM")*(0.1+(level*0.005))
		SFXR.frame_sfx("bell", i.get_global_rect())
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
	
	user.emit_signal("skill_end", self)
	user.end_turn()
