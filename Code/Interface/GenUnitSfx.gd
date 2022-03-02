extends Node


func _ready():
	get_parent().connect("pre_applied_dmg", self, "on_dmg")
	get_parent().connect("missed", self, "on_miss")
	get_parent().connect("drained_mp", self, "on_mp_drain")
	get_parent().connect("mouse_entered", self, "show_stat_tip")
	get_parent().connect("mouse_exited", Tip, "hide")
	get_parent().connect("tree_exiting", Tip, "hide")

func show_stat_tip():
	Tip.set_disp([get_parent().get_stats_desc()])

func on_dmg(inst):
	if inst.dmg_type == DamageInstance.TYPE.HEAL:
		Curtain.ln(get_parent().name + " recovered " + str(inst.amount) + " HP")
		SFXR.heal_particles(get_parent().get_global_rect())
	else:
		Curtain.ln(get_parent().name + " lost " + str(inst.amount) + " HP")
	
	SFXR.dmg_num(get_parent().get_global_rect(), inst)

func on_miss(inst):
	Curtain.ln(get_parent().name 
	+ " missed! (" 
	+ str(GUtil.teddy(inst.target.get_stat_val("AVD") - get_parent().get_stat_val("HIT"))*100) 
	+ "% chance)")
	
	SFXR.generic_text(inst.target.get_global_rect(), "Miss!")

func on_mp_drain(drain):
	Curtain.ln(get_parent().name + " absorbed " + str(drain) + " MP")
