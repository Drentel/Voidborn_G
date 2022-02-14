extends Label
class_name TutLab

export (String, MULTILINE) var desc

func _ready():
	connect("mouse_entered", Tip, "set_disp", [[desc]])
	connect("mouse_exited", Tip, "hide")

func _on_TutLab_mouse_entered():
	pass # Replace with function body.

func _on_TutLab_mouse_exited():
	modulate.a = 0.2
