extends BasePassiveSkill

func _init():
	s_name = "Absolute accuracy"
	s_desc = "20% chance to make any attack homing"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/HomingChance.gd")
