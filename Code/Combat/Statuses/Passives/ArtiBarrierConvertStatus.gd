extends BaseArtiStatus

func _init():
	status_name = "CON"

func _ready():
	status_owner.connect("overheal", self, "on_overheal")

func get_desc():
	return """CON
""" + str(lvl*2) + "% of overhealing is converted into barrier"

func on_turn_start():
	pass

func on_overheal(amount):
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Barrier.gd"))
	nod.stacks = max(1, ceil(lvl*2*amount/100.0))
	Curtain.ln("Conversion activates, converting " + str(amount) + " overhealing into " + str(max(1, ceil(lvl*2*amount/100.0))) + " Barrier")
	status_owner.apply_status(nod)
