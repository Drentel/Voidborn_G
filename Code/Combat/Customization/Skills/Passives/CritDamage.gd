extends BasePassiveSkill

func _init():
	s_name = "Concentration"
	s_desc = "CTD increases by 10 when character starts the turn, but reset when a crit turn ends."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/CritDamageStatus.gd")
