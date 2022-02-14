extends BaseSkill

export var fumble_messages = [" fumbles!"]

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln(user.name + GUtil.arr_rand(fumble_messages))
	yield(get_tree().create_timer(0.1), "timeout")
	user.emit_signal("skill_end", self)
	user.end_turn()
