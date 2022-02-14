extends MapEvent

export var dialogue_path = "res://Dialogue/Area1/test.json"

func activate():
	var dia = $"/root/Root".switch_dialogue(dialogue_path)
	yield(dia, "tree_exited")
	.activate()
