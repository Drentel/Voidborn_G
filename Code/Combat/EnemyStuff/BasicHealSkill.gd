extends BaseSkill

export var messages = [" heals!"]
export var short_msgs = ["Heal"]

export var scale_stat = "ATK"
export var scale_mult = 1.0
export var repeats = 1
export var target_allies = false
export var mana_cost = 0

func use(user):
	user.emit_signal("skill_start", self)
	SFXR.generic_text(get_parent().get_global_rect(), GUtil.arr_rand(short_msgs))
	Curtain.ln(user.name + GUtil.arr_rand(messages))
	if mana_cost > 0:
		user.spend_mp(mana_cost)
	
	for _i in repeats:
		var inst = DamageInstance.new()
		inst.sender = user
		if target_allies:
			inst.target = user
			for i in find_manager().get_enemies():
				if float(i.hp)/i.get_stat_val("MHP") < float(inst.target.hp)/inst.target.get_stat_val("MHP"):
					inst.target = i
		else:
			inst.target = user
		inst.amount = ceil(user.get_stat_val(scale_stat)*scale_mult)
		inst.dmg_type = DamageInstance.TYPE.HEAL
		inst.pierce = 1.0
		inst.is_homing = true
		inst.is_able_crit = false
		user.send_dmg(inst)
		yield(get_tree().create_timer(0.2), "timeout")
	
	yield(get_tree().create_timer(0.1), "timeout")
	user.emit_signal("skill_end", self)
	user.end_turn()
