extends BaseStatus

var stacks: int

func _init():
	status_name = "RAG"

func _ready():
	status_owner.connect("sent_dmg", self, "on_sent_dmg")

func get_desc():
	return "RAG\nNext attack will deal " + str(stacks) + " more damage"

func handle_dupe(dupe):
	stacks += dupe.stacks

func on_sent_dmg(inst):
	if is_instance_valid(self) && get_parent() != null:
		if inst.target != inst.sender:
			Curtain.ln("Rage activates! " + str(stacks) + " bonus damage")
			inst.amount += stacks
			get_parent().remove_child(self)
			queue_free()
