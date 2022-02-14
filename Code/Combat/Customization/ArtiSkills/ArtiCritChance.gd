extends BaseArtiSkill

func _init():
	level = 1
	s_name = "Focus"
	s_desc = "CTR increases by 1~2 when character attacks but doesn't crit, but reset when a crit happens"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "CTR increases by 1~" + str(max(lvl, 2)) + " when character attacks but doesn't crit, but reset when a crit happens"

func start_combat():
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Passives/ArtiCritRateStatus.gd"))
	nod.lvl = level
	find_user().apply_status(nod)
