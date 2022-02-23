extends BasePassiveSkill

func _init():
	s_name = "Slippery"
	s_desc = "AVD increased by 0.1x of base value when hit. Bonus does not expire until end of combat"

func show_desc_tip(owner):
	Tip.set_disp(["AVD increased by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("AVD")*0.1)) + " when and hit. Bonus does not expire until end of combat."])

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/Slippery.gd")
