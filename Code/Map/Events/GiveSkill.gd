extends Node
# Will take the frist skill from GPlayer if left empty
# Or a specific skill otherwise
export var skill = ""
export var spend_aspect = true

func activate():
	if spend_aspect:
		GPlayer.generic_items["Aspect"] -= 1
	
	var give_skill
	
	if skill == "":
		give_skill = GPlayer.skill_pool.pop_back()
	else:
		give_skill = skill
	
	if give_skill == null:
		return
	
	GPlayer.skills.append(give_skill)
	var dialog = AcceptDialog.new()
	dialog.dialog_text = "New skill obtained!\n"
	dialog.dialog_text += load(give_skill).new().s_name
	
	dialog.window_title = "New skill!"
	
	$"/root/Root".add_child(dialog)
	dialog.connect("confirmed", self, "annihilate_dialog", [dialog])
	dialog.popup_centered()

func annihilate_dialog(dialog):
	dialog.get_parent().remove_child(dialog)
	dialog.queue_free()
