extends Control

export var only_sync = true
export var target_sync = "P"



func _ready():
	for i in get_children():
		i.connect("switched", self, "on_switched")

func on_switched():
	var target_symbol = target_sync
	if only_sync:
		target_symbol = get_children()[0].text
	
	var count = 0
	for i in get_children():
		if i.text == target_symbol:
			count += 1
	
	if count > 2 or not only_sync:
		for i in get_children():
			if i.text == target_symbol:
				i.theme = preload("res://Themes/puzzle_button_active.tres")
			else:
				i.theme = preload("res://Themes/puzzle_button_inactive.tres")
	else:
		for i in get_children():
			i.theme = preload("res://Themes/puzzle_button_inactive.tres")
