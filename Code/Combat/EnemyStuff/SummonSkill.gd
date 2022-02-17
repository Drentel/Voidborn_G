extends BaseSkill

export var messages = [" summons!"]
export var short_msgs = ["Summon"]

export var slots = []

export var mana_cost = 0

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln(user.name + GUtil.arr_rand(messages))
	SFXR.generic_text(get_parent().get_global_rect(), GUtil.arr_rand(short_msgs))
	if mana_cost > 0:
		user.spend_mp(mana_cost)
	
	for i in slots:
		user.get_manager().add_new_slot(i)
	
	user.emit_signal("skill_end", self)
	user.end_turn()
