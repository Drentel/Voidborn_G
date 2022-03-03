extends BaseSkill

func _init():
	s_name = "Bloodletting"
	s_desc = "Cost: 35 MP\nBuffs ATK and CRM by 1xTEC. Buff is doubled if overcasted"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 35 MP\nBuffs ATK and CRM by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("TEC"))) + ". Buff is doubled if overcasted"])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(35)
	
	var nod = Node.new()
	nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
	nod.stacks.append({"stat":"ATK", "val":user.get_stat_val("TEC")*2, "duration": 4})
	nod.stacks.append({"stat":"CRM", "val":user.get_stat_val("TEC")*2, "duration": 4})
	
	if user.mp > 0:
		for i in nod.stacks:
			i["val"] *= 0.5
	
	SFXR.frame_sfx("blood", user.get_global_rect())
	
	for i in nod.stacks:
		Curtain.ln("%s of %s is increased by %s for 3 turns" % [i["stat"], user.name, i["val"]])
	
	user.apply_status(nod)
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
