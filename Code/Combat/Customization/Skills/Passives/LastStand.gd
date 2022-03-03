extends BasePassiveSkill


func _init():
	s_name = "Last Stand"
	s_desc = "Damage multiplier increased by 1x for every dead ally (doubled at one, tripled at 3, and so on)"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/LastStand.gd")
