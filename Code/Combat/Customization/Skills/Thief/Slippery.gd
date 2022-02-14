extends BasePassiveSkill


func _init():
	s_name = "Slippery"
	s_desc = "AVD increased by 0.1x of base value when attacked and hit. Bonus does not expire until end of combat."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/Slippery.gd")
