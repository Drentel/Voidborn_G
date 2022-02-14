extends MapEvent

export var scenario_path = "res://Placeholders/test_combat_scenario.tres"

func activate():
	var cmb = $"/root/Root".switch_combat(scenario_path)
	cmb.connect("combat_won", self, "on_win")
	cmb.connect("combat_lost", self, "on_lost")

func on_win():
	if get_children().size() > 0:
		get_children()[0].activate()

func on_lost():
	if get_children().size() > 1:
		get_children()[1].activate()
