extends BaseSkill

func _init():
	s_name = "Smoke pop"
	s_desc = "Halves HIT of all enemies for 3 turns"

func show_desc_tip(owner):
	Tip.set_disp(["Halves HIT of all enemies for 3 turns"])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	
	SFXR.spawn_smoke()
	
	for i in find_manager().get_enemies():
		var nod = Node.new()
		nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
		nod.stacks.append({"stat":"HIT", "val":i.get_stat_val("HIT")*(-0.5), "duration": 3})
		Curtain.ln("%s's HIT is reduced by %s for 3 turns" % [i.name, i.get_stat_val("HIT")*(-0.5)])
		i.apply_status(nod)
	
	yield(get_tree().create_timer(0.4), "timeout")
	user.emit_signal("skill_end", self)
	user.end_turn()

