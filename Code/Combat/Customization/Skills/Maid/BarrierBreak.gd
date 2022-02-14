extends BaseSkill

func check_usability(unit):
	if "BAR" in unit.get_status_names():
		return true
	else:
		return false

func _init():
	s_name = "Barrier Burst"
	s_desc = """Cost: 15 MP\nRemoves all barrier, and boosts ATK and DEF by 0.2x of its value for 3 turns
Also deals 0.5x of value as unavoidable magic damage to all enemies"""

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	user.spend_mp(15)
	
	var targets = find_manager().get_enemies()
	var barrier
	for i in user.get_statuses():
		if i.status_name == "BAR":
			barrier = i
	var barrier_stacks = barrier.stacks
	Curtain.ln("Lost all barrier (%s)" % [barrier_stacks])
	
	var status = Node.new()
	status.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
	status.stacks = [
		{"stat": "ATK",
		"val": barrier_stacks*0.2,
		"duration": 4},
		{"stat": "DEF",
		"val": barrier_stacks*0.2,
		"duration": 4}
	]
	
	for i in status.stacks:
		Curtain.ln("%s of %s is increased by %s for 3 turns" % [i["stat"], user.name, i["val"]])
	
	user.apply_status(status)
	
	for target in targets:
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.MAG
		inst.sender = user
		inst.target = target
		inst.amount = barrier_stacks*0.5
		inst.pierce = 0
		inst.is_homing = true
		SFXR.frame_sfx("bell", target.get_global_rect(), Color.orange, false, true, true)
		user.send_dmg(inst)
	
	$"/root/Root".screen_shake(0.1)
	barrier.get_parent().remove_child(barrier)
	barrier.queue_free()

	user.emit_signal("skill_end", self)
	user.end_turn()
	
