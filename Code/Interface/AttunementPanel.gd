extends Control

func set_props(cntrl: Control):
	cntrl.size_flags_vertical = SIZE_SHRINK_CENTER + SIZE_EXPAND

func _ready():
	yield(get_tree(), "idle_frame")
	unpack()

func unpack():
	var unit = $"../../".unit
	var apts = unit.get_attunement_pts()
	$AP.text = "AP: " + str(apts)
	
	GUtil.annihilate_children($Names)
	GUtil.annihilate_children($Values)
	GUtil.annihilate_children($Increments)
	GUtil.annihilate_children($Decrements)
	GUtil.annihilate_children($Modsums)
	
	for i in unit.attunement:
		var atn = Label.new()
		atn.text = i.capitalize()
		set_props(atn)
		$Names.add_child(atn)
		var atnv = Label.new()
		atnv.text = str(unit.attunement[i])
		set_props(atnv)
		$Values.add_child(atnv)
		var modsum = Label.new()
		for j in AllyUnit.attunement_binds[i]:
			modsum.text += j + "+" + str(AllyUnit.attunement_power*unit.attunement[i]*GUtil.stat_weight[j]) + " "
		set_props(modsum)
		$Modsums.add_child(modsum)
		
		var incrementer = ClackButton.new()
		incrementer.text = "+"
		set_props(incrementer)
		if apts > 0:
			incrementer.connect("pressed", self, "increment", [i])
		else:
			incrementer.disabled = true
		$Increments.add_child(incrementer)
		
		var decrementer = ClackButton.new()
		decrementer.text = "-"
		set_props(decrementer)
		if unit.attunement[i] > 0:
			decrementer.connect("pressed", self, "decrement", [i])
		else:
			decrementer.disabled = true
		$Decrements.add_child(decrementer)

func increment(category):
	$"../../".unit.attunement[category] += 1
	$"../../".unit.unpack()
	$"../../".upd_vals()

func decrement(category):
	$"../../".unit.attunement[category] -= 1
	$"../../".unit.unpack()
	$"../../".upd_vals()
