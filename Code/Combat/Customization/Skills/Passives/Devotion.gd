extends BasePassiveSkill


func _init():
	s_name = "Devotion"
	s_desc = "Whenever an ally is damaged, gain 0.5x of damage received as fury. Damage to this character doesn't count"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/KnightDevotion.gd")
