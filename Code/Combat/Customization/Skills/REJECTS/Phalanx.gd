extends BaseSkill

# Old version of Phalanx
# Might still fit on some support idk just rename it

func _init():
	s_name = "Phalanx"
	s_desc = "Cost: 20 MP\nBuffs DEF of all allies by 0.3 of caster's base DEF for 3 turns"

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(20)
	
	for i in find_manager().get_living_allies():
		var nod = Node.new()
		SFXR.frame_sfx("shield", i.get_global_rect())
		yield(get_tree().create_timer(0.1), "timeout")
		nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
		if i == user:
			nod.stacks.append({"stat":"DEF", "val":user.get_base_stat_val("DEF")*0.3, "duration": 4})
		else:
			nod.stacks.append({"stat":"DEF", "val":user.get_base_stat_val("DEF")*0.3, "duration": 3})
		i.apply_status(nod)
		Curtain.ln("DEF of %s is increased by %s for 3 turns" % [i.name, user.get_base_stat_val("DEF")*0.3])
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
