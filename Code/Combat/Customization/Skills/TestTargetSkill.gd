extends BaseSkill

func _init():
	s_name = "Test target"
	s_desc = "Deals static 1 damage to target"

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_everyone()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		target.hp_set(target.hp_get() - 1)
		yield(get_tree().create_timer(0.1), "timeout")
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
