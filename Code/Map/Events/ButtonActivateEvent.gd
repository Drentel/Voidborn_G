extends MapEvent
class_name MapButtonEvent

signal buttons_required(btns)

func activate():
	var btns = []
	for i in get_children():
		var btn = ClackButton.new()
		btn.text = i.name
		btn.connect("pressed", i, "activate")
		btns.append(btn)
	
	emit_signal("buttons_required", btns)
