extends BaseSkill
class_name BaseWeaponSkill

var item_base_name = "Sword"
var possible_stats = ["ATK"]

func _init():
	s_name = "Sword attack"
	s_desc = "Deals 1xATK damage to target"

func show_desc_tip(owner):
	Tip.set_disp(["Deals " + GUtil.wrap_highlight(ceil(owner.get_base_stat_val("ATK"))) + " damage to target"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.PHYS
		inst.sender = user
		inst.target = target
		inst.amount = user.get_stat_val("ATK")
		SFXR.frame_sfx("sword", inst.target.get_global_rect(), Color.wheat)
		yield(get_tree().create_timer(0.15), "timeout")
		$"/root/Root".screen_shake(0.1)
		user.send_dmg(inst)
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)
