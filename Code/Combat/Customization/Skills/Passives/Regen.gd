extends BasePassiveSkill

func _init():
	s_name = "Regeneration"
	s_desc = "Heal for 0.15xMHP at the start of turn"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/RegenStatus.gd")
