extends BaseSkill

func _init():
	s_name = "Firebolt"
	s_desc = "Cost: 20 MP\nDeals 1.5xCRM magic damage, and inflicts half of damage dealt as burn. Homing"

func show_desc_tip(owner):
	Tip.set_disp(["Cost: 20 MP\nDeals " + GUtil.wrap_highlight(ceil(owner.get_stat_val("CRM")*1.5)) + " magic damage, and inflicts half of damage dealt as burn. Homing"])

func use(user):
	user.emit_signal("skill_start", self)
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	c_manager.get_controls().display_targets(targets)
	var target = yield(c_manager.get_controls(), "target_selected")
	if not target is int:
		Curtain.ln("%s uses %s" % [user.name, s_name])
		user.spend_mp(20)

		var inst = DamageInstance.new()
		inst.dmg_type = DamageInstance.TYPE.MAG
		inst.sender = user
		inst.target = target
		inst.amount = user.get_stat_val("CRM")*1.5
		#SFXR.frame_sfx("sword", inst.target.get_global_rect(), Color.goldenrod)
		yield(get_tree().create_timer(0.2), "timeout")
		$"/root/Root".screen_shake(0.1)
		inst.connect("dmg_applied", self, "dmg_dealt", [inst])
		user.send_dmg(inst)
		
		user.emit_signal("skill_end", self)
		user.end_turn()
	else:
		user.emit_signal("nonturnend_skill_end", self)

func dmg_dealt(inst):
	var status = preload("res://Code/Combat/Statuses/Burn.gd").new()
	status.stacks = ceil(inst.amount/2)
	
	Curtain.ln("%s receives %s burn" % [inst.target.name, status.stacks])
	
	inst.target.apply_status(status)
