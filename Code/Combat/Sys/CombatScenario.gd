extends Resource
class_name CombatScenario

export var skip_first_name = false;
export var first_is_enough = false;

export var mana_min = 100
export var mana_max = 200
export var slots = [
	{"pos": Vector2(100, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	{"pos": Vector2(200, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	{"pos": Vector2(300, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	]

func _init():
	pass
