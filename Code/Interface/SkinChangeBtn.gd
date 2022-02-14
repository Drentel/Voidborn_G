extends ClackButton

func _ready():
	pass

func _on_FileDialog_dir_selected(dir):
	get_parent().unit.set_skin(dir)

func _on_SkinChangeBtn_pressed():
	$FileDialog.popup_centered()
