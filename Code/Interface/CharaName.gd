extends ToolButton

func _on_CharaName_pressed():
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	$"../../".unit.name = $ConfirmationDialog/LineEdit.text
	$"../../".upd_vals()
