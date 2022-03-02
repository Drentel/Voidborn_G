extends BaseStatus

func _init():
	status_name = "CON"

func _ready():
	status_owner.connect("overheal", self, "on_overheal")

func get_desc():
	return """CON
25% of overhealing is converted into barrier"""

func on_overheal(amount):
	var nod = Node.new()
	nod.set_script(load("res://Code/Combat/Statuses/Barrier.gd"))
	nod.stacks = max(1, ceil(amount*0.25))
	Curtain.ln("Conversion activates, converting " + str(amount) + " overhealing into " + str(nod.stacks) + " Barrier")
	status_owner.apply_status(nod)
