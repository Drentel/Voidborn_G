extends BasePassiveSkill

func _init():
	s_name = "Barrier conversion"
	s_desc = "Overhealing is converted into barrier at 25% efficiency"

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/BarrierConvertStatus.gd")
