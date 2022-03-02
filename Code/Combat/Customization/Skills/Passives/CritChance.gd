extends BasePassiveSkill

func _init():
	s_name = "Focus"
	s_desc = "CTR increases by 10 when character starts the turn, but reset when a crit turn ends."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/CritRateStatus.gd")
