extends BasePassiveSkill

func _init():
	s_name = "Piercing"
	s_desc = "All attacks ignore 20% of target damage reduction"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/PierceIncrease.gd")
