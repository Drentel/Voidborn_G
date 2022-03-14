extends MapEvent

export var puzzle = "res://Scenes/Puzzles/SyncPuzzleTest.tscn"

var solved = false

func activate():
	solved = false
	var dialog = WindowDialog.new()
	
	var lpuzzle = load(puzzle).instance()
	lpuzzle.name = "puzzle"
	
	dialog.rect_size = lpuzzle.rect_size
	dialog.add_child(lpuzzle)
	
	dialog.connect("popup_hide", self, "dialog_closed", [dialog])
	dialog.get_node("puzzle").connect("solved", self, "puzzle_solved", [dialog])
	
	$"/root/Root".add_child(dialog)
	dialog.popup_centered()
	
	

func dialog_closed(dialog):
	if not solved:
		activate_num(1)
		annihilate_dialog(dialog)

func puzzle_solved(dialog):
	solved = true
	.activate_num(0)
	annihilate_dialog(dialog)

func annihilate_dialog(dialog):
	dialog.get_parent().remove_child(dialog)
	dialog.queue_free()
