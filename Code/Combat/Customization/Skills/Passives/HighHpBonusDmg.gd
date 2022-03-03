extends BasePassiveSkill


func _init():
	s_name = "Giant slayer"
	s_desc = "Deal 1.2x damage to enemies that have more HP than you"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/HighHpBonusDmg.gd")
