extends BaseSkill

func _init():
	s_name = "Determination"
	s_desc = "Reduces the duration of all STT decreases on all allies by 1."

func show_desc_tip(owner):
	Tip.set_disp(["Reduces the duration of all STT decreases on all allies by 1."])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	
	for i in find_manager().get_living_allies():
		#SFXR.frame_sfx("shield", i.get_global_rect(), Color.orange)
		#yield(get_tree().create_timer(0.1), "timeout")
		
		for j in i.get_statuses():
			if j is StatModStatus:
				for idk in j.stacks:
					if idk["val"] < 0:
						idk["duration"] -= 1
				j.clean()
	
	user.emit_signal("skill_end", self)
	user.end_turn()
	
