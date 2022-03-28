extends Node
# Will take the frist skill from GPlayer if left empty
# Or a specific skill otherwise
export var skill = ""

func activate():
	GPlayer.echoes.append(skill)
	var dialog = AcceptDialog.new()
	dialog.dialog_autowrap = true
	dialog.rect_size = Vector2(0, 0)
	var lski = load(skill).new()
	dialog.dialog_text += lski.s_name + "\n"
	dialog.dialog_text += lski.s_desc
	
	dialog.window_title = "New echo!"
	
	$"/root/Root".add_child(dialog)
	dialog.connect("confirmed", self, "annihilate_dialog", [dialog])
	dialog.popup_centered()

func annihilate_dialog(dialog):
	dialog.get_parent().remove_child(dialog)
	dialog.queue_free()
