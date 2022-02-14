extends BaseSkill

func _init():
	s_name = "Smoke pop"
	s_desc = "Cost: 20 MP\nReduces HIT of all enemies by 0.8xTEC for 3 turns"

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(20)
	
	SFXR.spawn_smoke()
	
	for i in find_manager().get_enemies():
		var nod = Node.new()
		nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
		nod.stacks.append({"stat":"HIT", "val":user.get_stat_val("TEC")*(-0.8), "duration": 3})
		i.apply_status(nod)
		Curtain.ln("%s's HIT is reduced by %s for 3 turns" % [i.name, user.get_stat_val("TEC")*(-0.8)])
	
	yield(get_tree().create_timer(0.4), "timeout")
	user.emit_signal("skill_end", self)
	user.end_turn()
	
