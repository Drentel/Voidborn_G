extends BasePassiveSkill

func _init():
	s_name = "Cute"
	s_desc = "Receiving damage grants all allies except self fury equal to half of it."

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/PrincessCute.gd")
