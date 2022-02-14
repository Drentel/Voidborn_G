extends BasePassiveSkill

func _init():
	s_name = "Keen edge"
	s_desc = "CTD is increased by 0.1x of base value on crit. Accumulated increase is reduced by same value at the end of turn."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/AssAssInKeenEdge.gd")
