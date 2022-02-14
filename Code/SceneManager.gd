extends Control

func switch_combat(var scenario: String):
	var cmbt = load("res://Scenes/Combat.tscn").instance()
	cmbt.scenario_path = scenario
	add_child(cmbt)
	cmbt.connect("tree_exiting", self, "switch_map")

func switch_edit():
	var edi = load("res://Scenes/EditScene.tscn").instance()
	add_child(edi)
	get_parent().move_child(self, 1)
	edi.connect("tree_exiting", self, "switch_map")

func switch_map():
	get_parent().move_child(self, 3)

func _ready():
	pass
