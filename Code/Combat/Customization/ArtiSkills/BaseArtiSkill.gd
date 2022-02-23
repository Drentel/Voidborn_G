extends BasePassiveSkill
class_name BaseArtiSkill

export var level = 1

func _init():
	s_name = "Skill name"
	s_desc = "Do something"

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += "do something at level " + str(level)

func start_combat():
	pass
