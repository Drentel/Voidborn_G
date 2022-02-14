extends BaseSkill

func _init():
	s_name = "Reinforce"
	s_desc = "Cost: 60 MP\nDoubles DEF but havles ATK for 5 turns."

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(50)
	
	var nod = Node.new()
	nod.set_script(preload("res://Code/Combat/Statuses/StatMod.gd"))
	nod.stacks.append({
		"stat":"DEF", 
		"val":user.get_base_stat_val("DEF"), 
		"duration": 6})
	
	nod.stacks.append({
		"stat":"ATK", 
		"val":user.get_base_stat_val("ATK")*(-0.5), 
		"duration": 6})
	
	for i in nod.stacks:
		Curtain.ln("%s of %s is increased by %s for 5 turns" % [i["stat"], user.name, i["val"]])
	
	SFXR.frame_sfx("shield", user.get_global_rect())
	yield(get_tree().create_timer(0.1), "timeout")
	
	user.apply_status(nod)
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
