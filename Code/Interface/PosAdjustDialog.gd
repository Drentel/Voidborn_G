extends WindowDialog

var unit

func _on_Button_pressed():
	popup_centered()

func _on_left_pressed():
	unit.pos_adjust.x -= int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_zoom_plus_pressed():
	unit.zoom_adjust += int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_zoom_minus_pressed():
	unit.zoom_adjust -= int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_up_pressed():
	unit.pos_adjust.y -= int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_right_pressed():
	unit.pos_adjust.x += int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_down_pressed():
	unit.pos_adjust.y += int($amount.text)
	unit.emit_signal("selected")
	upd_off_info()

func _on_PosAdjustDialog_about_to_show():
	unit = $"../../".unit
	upd_off_info()

func _on_flip_pressed():
	unit.flip = !unit.flip
	unit.emit_signal("selected")
	upd_off_info()

func upd_off_info():
	$OffInfo.text = "\"offset_x\": %s,\n\"offset_y\": %s,\n\"zoom\": %s,\n\"flip\": %s" % [unit.pos_adjust.x, unit.pos_adjust.y, unit.zoom_adjust, str(unit.flip).to_lower()]
