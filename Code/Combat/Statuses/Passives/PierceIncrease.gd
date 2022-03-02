extends BaseStatus

func _init():
	status_name = "PIR"

func _ready():
	status_owner.connect("pre_determine_hit", self, "on_pre_determine_hit")

func get_desc():
	return """PIR
Every attack ignores aditional 20% of target damage reduction"""

func on_pre_determine_hit(inst):
	inst.pierce += 0.2
	if inst.pierce > 1.0:
		inst.pierce = 1.0
