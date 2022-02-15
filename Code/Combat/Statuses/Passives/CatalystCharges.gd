extends BaseStatus

var stacks = 1

func _init():
	status_name = "CHR"

func _ready():
	status_owner.connect("turn_start", self, "on_turn_start")

func get_desc():
	return """CHR
Catalyst has """ + str(stacks) + " charges. Increases by 1 at the start of turn."

func on_turn_start():
	stacks += 1
