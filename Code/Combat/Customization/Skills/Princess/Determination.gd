extends BaseSkill

func _init():
	s_name = "Determination"
	s_desc = "Cost: 50 MP\nReduces the duration of all STT decreases on all allies by 1. Has a TEC-dependent chance of reducing twice"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 50 MP\nnReduces the duration of all STT decreases on all allies by 1. Has a " + GUtil.wrap_highlight(GUtil.disp_decim(GUtil.teddy(owner.get_stat_val("TEC"))*100)) + "% chance of reducing twice"])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(50)
	
	for i in find_manager().get_living_allies():
		#SFXR.frame_sfx("shield", i.get_global_rect(), Color.orange)
		#yield(get_tree().create_timer(0.1), "timeout")
		
		for j in i.get_statuses():
			if j is StatModStatus:
				for idk in j.stacks:
					if idk["val"] < 0:
						if randi()%100 < GUtil.teddy(user.get_stat_val("TEC")*100):
							idk["duration"] -= 1
						else:
							idk["duration"] -= 2
				j.clean()
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
