extends BasePassiveSkill

func _init():
	s_name = "Stubborness"
	s_desc = "Survive fatal DMG with 1 HP once"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/Stubborness.gd")
