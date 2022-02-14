extends BaseArtiStatus

func _init():
	status_name = "ACC"

func _ready():
	status_owner.connect("pre_determine_hit", self, "on_pre_determine_hit")

func get_desc():
	return """ACC
""" + str(ceil(100*GUtil.teddy(lvl))) + "% chance to make any attack homing"

func on_turn_start():
	pass

func on_pre_determine_hit(inst):
	if randi()%100 < ceil(100*GUtil.teddy(lvl)):
		Curtain.ln("ACC activates! Attack became homing")
		inst.is_homing = true
