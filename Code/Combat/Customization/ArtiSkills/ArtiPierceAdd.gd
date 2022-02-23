extends BaseArtiSkill

func _init():
	level = 1
	s_name = "Piercing"
	s_desc = "All attacks ignore 1% of target armor"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "All attacks ignore " + str(GUtil.disp_decim(GUtil.teddy(level)*80)) + "% of target armor"

func start_combat():
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Passives/ArtiPierceIncrease.gd"))
	nod.lvl = level
	find_user().apply_status(nod)
