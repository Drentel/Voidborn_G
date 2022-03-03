extends BaseSkill

func _init():
	s_name = "Sharpen"
	s_desc = "Cost: 70 MP\nBuffs CTD and CTR by 1x TEC, but halves DEF for 3 turns"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 70 MP\nBuffs CTD and CTR by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("TEC"))) + ", but halves DEF for 3 turns."])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(70)
	var status = Node.new()
	status.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
	status.stacks = [
		{"stat": "CTD",
		"val": user.get_stat_val("TEC"),
		"duration": 4},
		{"stat": "CTR",
		"val": user.get_stat_val("TEC"),
		"duration": 4},
		{"stat": "DEF",
		"val": user.get_stat_val("DEF")*(-0.5),
		"duration": 4}
	]
	SFXR.frame_sfx("swordup", user.get_global_rect())
	user.apply_status(status)
	for j in status.stacks:
		Curtain.ln("%s of %s is increased by %s for 3 turns" % [j["stat"], user.name, j["val"]])
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
