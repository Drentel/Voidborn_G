extends Resource
class_name CombatScenario

export var mana_min = 100
export var mana_max = 200
export var slots = [
	{"pos": Vector2(100, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	{"pos": Vector2(200, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	{"pos": Vector2(300, 200), "enemies":["res://Placeholders/TestEnemy.tscn"]},
	]

func _init():
	pass
