extends Control

signal solved()

export var only_sync = true
export var target_sync = "0"
export var random_actions = 10

func _ready():
	for _i in range(random_actions):
		GUtil.arr_rand($Puzzle.get_children()).on_press()
	
	for i in $Puzzle.get_children():
		i.connect("switched", self, "on_switched")
	on_switched()

func reset_theming():
	for i in $Puzzle.get_children():
		i.theme = preload("res://Themes/puzzle_button_inactive.tres")

func on_switched():
	reset_theming()
	$ConfirmBtn.disabled = true
	
	var occurences = {}
	for i in $Puzzle.get_children():
		if i.text in occurences.keys():
			occurences[i.text] += [i]
		else:
			occurences[i.text] = [i]
	
	if not only_sync:
		if target_sync in occurences.keys():
			for i in occurences[target_sync]:
				i.theme = preload("res://Themes/puzzle_button_active.tres")
			if occurences[target_sync].size() == $Puzzle.get_child_count():
				$ConfirmBtn.disabled = false
	else:
		var lobj = occurences.values()[0]
		for i in occurences.values():
			if lobj.size() < i.size():
				lobj = i
				
		if lobj.size() > 1:
			for i in lobj:
				i.theme = preload("res://Themes/puzzle_button_active.tres")
			if lobj.size() == $Puzzle.get_child_count():
				$ConfirmBtn.disabled = false


func _on_ConfirmBtn_pressed():
	emit_signal("solved")
