extends Button

func nuke():
	get_parent().remove_child(self)
	queue_free()

func disp_stuff(stuff):
	$Panel/RichTextLabel.bbcode_text = stuff

func _on_Button_pressed():
	nuke()

func _on_LootDisp_pressed():
	nuke()
