extends BasePassiveSkill


func _init():
	s_name = "Splitting care"
	s_desc = "1/turn: Dealing damage will heal ally with lowest %HP for 0.5x of attack's damage dealt. This increases to 1x damage dealt if attacker has a barrier."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/MaidHitRegen.gd")
