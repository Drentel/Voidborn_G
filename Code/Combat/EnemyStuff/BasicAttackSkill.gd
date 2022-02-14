extends BaseSkill

export var messages = [" attacks!"]
export var short_msgs = ["Attack"]

export var scale_stat = "ATK"
export var scale_mult = 1.0
export(DamageInstance.TYPE) var dmg_type = DamageInstance.TYPE.PHYS
export var pierce = 0.0
export var is_homing = false
export var is_able_crit = true
export var repeats_max = 1
export var repeats_min = 1
export var effect = "bell"
export var modulate = Color.white
export var shake = 0.1
export var delay = 0.2
export var mana_cost = 0

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln(user.name + GUtil.arr_rand(messages))
	SFXR.generic_text(get_parent().get_global_rect(), GUtil.arr_rand(short_msgs))
	if mana_cost > 0:
		user.spend_mp(mana_cost)
	
	var repeats
	if repeats_max != repeats_min:
		repeats = randi()%(repeats_max-repeats_min)+repeats_min
	else:
		repeats = repeats_max
	
	for _i in range(repeats):
		if find_manager().get_living_allies().size() > 0:
			var inst = DamageInstance.new()
			inst.sender = user
			inst.target = find_manager().get_ally_target_pool().pick()
			inst.amount = ceil(user.get_stat_val(scale_stat)*scale_mult)
			inst.dmg_type = dmg_type
			inst.pierce = pierce
			inst.is_homing = is_homing
			inst.is_able_crit = is_able_crit
			SFXR.frame_sfx(effect, inst.target.get_global_rect(), modulate)
			yield(get_tree().create_timer(delay), "timeout")
			$"/root/Root".screen_shake(shake)
			user.send_dmg(inst)
			yield(get_tree().create_timer(0.2), "timeout")
	
	user.emit_signal("skill_end", self)
	user.end_turn()
