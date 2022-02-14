extends BasePassiveSkill
class_name BaseArtiSkill

export var level = 1

func _init():
	s_name = "Regeneration"
	s_desc = "Heal for 0.01xMHP at the start of turn"

func set_level(lvl: int):
	level = lvl
	s_desc = "Heal for " + str(round(GUtil.teddy(level)*100)/100.0) + "xMHP at the start of turn"

func start_combat():
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Passives/ArtiRegenStatus.gd"))
	nod.lvl = level
	find_user().apply_status(nod)
