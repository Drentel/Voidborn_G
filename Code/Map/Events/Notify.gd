extends MapEvent

export var notification = "notification"

func activate():
	var dialog = AcceptDialog.new()
	dialog.dialog_autowrap = true
	dialog.rect_size = Vector2(0, 0)
	dialog.dialog_text = notification
	
	$"/root/Root".add_child(dialog)
	dialog.connect("confirmed", self, "annihilate_dialog", [dialog])
	dialog.popup_centered()

func annihilate_dialog(dialog):
	dialog.get_parent().remove_child(dialog)
	dialog.queue_free()
	.activate()
