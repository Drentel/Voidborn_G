extends BaseSkill

func _init():
	s_name = "Switch"
	s_desc = "Instantly switches to another ally, but debuffs the user's SPD by 40% of its original value for 3 turns"

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_living_allies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		var nod = Node.new()
		nod.set_script(load("res://Code/Combat/Statuses/StatMod.gd"))
		nod.stacks.append({"stat":"SPD", "val":user.get_base_stat_val("SPD")*(-0.4), "duration": 4})
		user.apply_status(nod)
		c_manager.get_turn_order().force_add(target)
		Curtain.ln(user.name + " switches with " + target.name)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
