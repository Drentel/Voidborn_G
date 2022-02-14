extends BaseArtiSkill

func _init():
	level = 1
	s_name = "Barrier conversion"
	s_desc = "Overhealing is converted into barrier at 2% efficiency"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "Overhealing is converted into barrier at " + str(lvl*2) + "% efficiency"

func start_combat():
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Passives/ArtiBarrierConvertStatus.gd"))
	nod.lvl = level
	find_user().apply_status(nod)
