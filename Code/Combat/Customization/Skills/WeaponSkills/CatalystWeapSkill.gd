extends BaseWeaponSkill

func _init():
	item_base_name = "Catalyst"
	possible_stats = ["CRM", "MMP"]

	s_name = "Catalyst attack"
	s_desc = """Consumes all charges and attacks once per charge consumed. 1 charge is gained at the start of turn.
Every attack deals 0.3xCRM magic damage to one random enemy."""

func set_level(lvl: int):
	level = lvl
	s_desc = "Level %s\n" % [lvl]
	s_desc += """Consumes all charges and attacks once per charge consumed. 1 charge is gained at the start of turn.
Every attack deals %sxCRM magic damage to one random enemy.""" % [0.3+(0.03*lvl)]

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln("%s uses %s" % [user.name, s_name])
	var c_manager = find_manager()
	var targets = c_manager.get_enemies()
	
	var repeats = 0
	
	for i in user.get_statuses():
		if i.script == preload("res://Code/Combat/Statuses/Passives/CatalystCharges.gd"):
			repeats = i.stacks
			i.stacks = 0
	
	for i in repeats:
		if c_manager.get_enemies().size() > 0:
			var inst = DamageInstance.new()
			inst.amount = user.get_stat_val("CRM")*(0.3+(0.03*level))
			inst.dmg_type = DamageInstance.TYPE.MAG
			inst.sender = user
			inst.target = GUtil.arr_rand(c_manager.get_enemies())
			
			SFXR.frame_sfx("lightning", inst.target.get_global_rect(), Color.white, false, false, false)
			yield(get_tree().create_timer(0.25), "timeout")
			$"/root/Root".screen_shake(0.1)
			user.send_dmg(inst)
		else:
			break
	
	user.emit_signal("skill_end", self)
	user.end_turn()

# Ye i had to copy this from passive skills
# This is kinda bad but also lmao i'm not making a different type for one skill

func find_user(nod = self):
	# This is stupid but i see no other way to avoid cyclic references
	if ("IS_UNIT" in nod):
		return nod
	else:
		return find_user(nod.get_parent())

func _ready():
	find_user().connect("entered_combat", self, "start_combat")

func start_combat():
	find_user().apply_status("res://Code/Combat/Statuses/Passives/CatalystCharges.gd")
