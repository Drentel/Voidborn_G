extends BaseSkill

func _init():
	s_name = "Bloodletting"
	s_desc = "Cost: 0.2xMHP\nBuffs ATK and CRM by 1xTEC. Will not kill."

func show_desc_tip(owner):
	Tip.set_disp(["Cost: " + GUtil.wrap_highlight(ceil(owner.get_stat_val("MHP")*0.3)) + " HP\nBuffs ATK and CRM by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("TEC"))) + ". Will not kill."])

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	var dmg = DamageInstance.new()
	dmg.target = user
	dmg.sender = user
	dmg.is_able_crit = false
	dmg.pierce = 1
	dmg.amount = ceil(user.get_stat_val("MHP")*0.3)
	dmg.dmg_type = DamageInstance.TYPE.PHYS
	dmg.is_homing = true
	if dmg.amount > user.hp:
		dmg.amount = user.hp - 1
	
	if dmg.amount > 0:
		user.send_dmg(dmg)
	
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
	
