extends BaseSkill

func _init():
	s_name = "Shred"
	s_desc = "Cost: 60 MP\nDeals 2xATK damage thrice, and then reduces the target's DEF by 0.3xATK for 3 turns"

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(60)
		
		for i in range(3):
			if !is_instance_valid(target): # This is in case the initial target dies
				if c_manager.get_enemies().size() > 0:
					target = GUtil.arr_rand(c_manager.get_enemies())
				else:
					break
			
			var inst = DamageInstance.new()
			inst.dmg_type = DamageInstance.TYPE.PHYS
			inst.sender = user
			inst.target = target
			inst.amount = user.get_stat_val("ATK")*2
			SFXR.frame_sfx("sword", inst.target.get_global_rect(), Color.brown, i%2==0, false, false)
			yield(get_tree().create_timer(0.2), "timeout")
			$"/root/Root".screen_shake(0.1)
			user.send_dmg(inst)
			yield(get_tree(), "idle_frame")
		
		if is_instance_valid(target):
			var status = Node.new()
			status.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
			status.stacks = [
				{"stat": "DEF",
				"val": user.get_stat_val("ATK")*0.3*(-1),
				"duration": 3}
			]
			
			for i in status.stacks:
				Curtain.ln("%s of %s is decreased by %s for 3 turns" % [i["stat"], user.name, i["val"]])
			
			target.apply_status(status)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
