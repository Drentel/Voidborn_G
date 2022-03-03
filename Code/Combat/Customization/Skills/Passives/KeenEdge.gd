extends BasePassiveSkill

func _init():
	s_name = "Keen edge"
	s_desc = "CTD is increased by 0.05x of base value on crit"

func show_desc_tip(owner):
	Tip.set_disp(["CTD is increased by " + GUtil.wrap_highlight(ceil(owner.get_stat_val("CTD")*0.05)) + " on crit"])

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/AssAssInKeenEdge.gd")
