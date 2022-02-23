extends BaseArtiStatus

func _init():
	status_name = "PIR"

func _ready():
	status_owner.connect("pre_determine_hit", self, "on_pre_determine_hit")

func get_desc():
	return """PIR
Every attack ignores """ + str(GUtil.disp_decim(80*GUtil.teddy(lvl))) + "% of target DEF"

func on_pre_determine_hit(inst):
	inst.pierce += GUtil.teddy(lvl)*0.8
	if inst.pierce > 1.0:
		inst.pierce = 1.0
