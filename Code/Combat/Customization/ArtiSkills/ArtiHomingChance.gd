extends BaseArtiSkill

func _init():
	level = 1
	s_name = "Absolute accuracy"
	s_desc = "1% chance to make any attack homing"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += str(ceil(100*GUtil.teddy(lvl))) + "% chance to make any attack homing"

func start_combat():
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Passives/ArtiHomingChance.gd"))
	nod.lvl = level
	find_user().apply_status(nod)
