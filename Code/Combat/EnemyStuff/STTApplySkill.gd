extends BaseSkill

export var messages = [" buffs!"]
export var short_msgs = ["Buff"]

export var buffs = [{"val": 10, "stat": "ATK", "duration": 3}]
# Duration will be auto-extended by 1 if target is self
export(int, "Self", "Allies", "AlliesNotSelf", "Random") var buff_target
export var repeats = 1
export var mana_cost = 0

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln(user.name + GUtil.arr_rand(messages))
	SFXR.generic_text(get_parent().get_global_rect(), GUtil.arr_rand(short_msgs))
	if mana_cost > 0:
		user.spend_mp(mana_cost)
	
	for i in repeats:
		var targets = []
		if buff_target == 0:
			targets.append(get_parent())
		elif buff_target == 1:
			targets += get_parent().get_manager().get_enemies()
		elif buff_target == 2:
			targets += get_parent().get_manager().get_enemies()
			targets.erase(get_parent())
		elif buff_target == 3:
			targets.append(GUtil.arr_rand(get_parent().get_manager().get_enemies()))
		
		for j in targets:
			var stt = StatModStatus.new()
			stt.stacks = buffs
			if j == get_parent():
				for idk in stt.stacks:
					idk["duration"] += 1
			j.apply_status(stt)
	
	
	user.emit_signal("skill_end", self)
	user.end_turn()
