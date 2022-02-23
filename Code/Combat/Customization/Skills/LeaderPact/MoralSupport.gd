extends BasePassiveSkill

func _init():
	s_name = "Moral Support"
	s_desc = "All ally attacks deal 1.2x damage. This multiplier becomes 0.8x if this unit is dead. Does not influence this unit's attacks"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/LeaderSupport.gd")
