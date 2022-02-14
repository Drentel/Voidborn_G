extends BaseSkill

func _init():
	s_name = "Phalanx"
	s_desc = "Cost: 20 MP\nGrants barrier equal to 1xDEF to all allies."

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(20)
	
	for i in find_manager().get_living_allies():
		SFXR.frame_sfx("shield", i.get_global_rect(), Color.orange)
		yield(get_tree().create_timer(0.1), "timeout")
		
		var nod = Node.new()
		nod.set_script(load("res://Code/Combat/Statuses/Barrier.gd"))
		nod.stacks = user.get_stat_val("DEF")
		Curtain.ln("%s gains %s barrier" % [i.name, user.get_stat_val("DEF")])
		i.apply_status(nod)
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
