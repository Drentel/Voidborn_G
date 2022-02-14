extends BasePassiveSkill


func _init():
	s_name = "Poison blade"
	s_desc = "Critical hits apply poison equal to 0.4x TEC to target."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/PoisonBlade.gd")
