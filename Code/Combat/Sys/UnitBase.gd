extends Node
class_name UnitBase

# Abstract class
# Shared behaviour between AllyUnit and EnemyUnit

# This is stupid. So are cyclic reference errors
const IS_UNIT = true

signal turn_start()
signal turn_end()
signal died()
signal dynamic_value_changed()
signal hp_changed(old, new)
signal mp_changed(old, new)
signal received_dmg(dmg_instance)
signal applied_dmg(dmg_instance)
signal sent_dmg(dmg_instance)
signal missed(dmg_instance)
signal critted(dmg_instance)
signal overheal(amount)
signal skill_start(skill)
signal skill_end(skill)
signal nonturnend_skill_end(skill)
signal drained_mp(amount)
signal pre_applied_dmg(inst)
signal overcast(amount)
signal pre_determine_hit(inst)
signal dodge(inst)

signal status_added(status)
signal status_removed(status)

signal entered_combat()
signal exited_combat()

export var lvl = 1
var status_node

func _ready():
	status_node = Node.new()
	status_node.name = "Statuses"
	add_child(status_node)

func get_stats_desc():
	var res = ""
	
	for i in GUtil.stat_definitions:
		res += "[font=res://Themes/monospace.tres]" + str(i) + "\t[/font]"
		
		if i in GUtil.teddy_definitions:
			res += str(GUtil.disp_decim(GUtil.teddy(get_stat_val(i)))) + "% "
		res += str(get_stat_val(i)) + " ("
		res += str(get_base_stat_val(i)) + "+"
		res += str(get_stat_val(i) - get_base_stat_val(i)) + ")\n"
		
	
	return res

# This one needs to be overriden in AllyUnit and EnemyUnit
func get_base_stat_val(stat: String):
	return get_stat_val(stat)

func spend_mp(amount):
	var new_val = mp - amount
	var overcast = 0
	if new_val < 0:
		Curtain.ln("Overcast! " + str(abs(new_val)*20) + " HP converted to MP")
		var dmg = DamageInstance.new()
		dmg.amount = abs(new_val)*20
		dmg.sender = self
		dmg.target = self
		dmg.pierce = 1.0
		dmg.is_homing = true
		dmg.is_able_crit = false
		dmg.dmg_type = DamageInstance.TYPE.MAG
		send_dmg(dmg)
		overcast = abs(new_val)
		new_val = 0
	mp_set(min(new_val, get_stat_val("MMP")))
	emit_signal("overcast", overcast)

func get_statuses():
	return status_node.get_children()

func get_status_names():
	var res = []
	for i in status_node.get_children():
		res.append(i.status_name)
	return res

func apply_status(status):
	if status is String:
		var nod = Node.new()
		nod.set_script(load(status))
		self.apply_status(nod)
	else:
		for i in get_statuses():
			if i.script == status.script:
				i.handle_dupe(status)
				return
		status.status_owner = self
		status_node.add_child(status)
		emit_signal("status_added", status)
		status.connect("tree_exiting", self, "status_removed", [status])

func status_removed(sta):
	emit_signal("status_removed", sta)

var hp: int setget hp_set, hp_get
func hp_set(new_value: int):
	if hp == new_value:
		return
	
	hp = new_value
	emit_signal("hp_changed", hp, new_value)
	emit_signal("dynamic_value_changed")
	
	if hp > get_stat_val("MHP"):
		emit_signal("overheal", hp - get_stat_val("MHP"))
		hp = get_stat_val("MHP")
	
	if hp <= 0:
		hp = 0
		die()

func hp_get():
	return hp

var mp: int setget mp_set, mp_get
func mp_set(new_value: int):
	if mp == new_value:
		return
	
	mp = new_value
	emit_signal("mp_changed", mp, new_value)
	emit_signal("dynamic_value_changed")

func mp_get():
	return mp

func start_turn():
	Curtain.ln("")
	Curtain.ln("Start of " + name + "'s turn")
	
	var drain = min(get_stat_val("MMP") - mp_get(), floor(get_manager().get_field_mana() * GUtil.teddy(get_stat_val("ABS"))))
	get_manager().set_field_mana(get_manager().get_field_mana() - drain)
	mp_set(mp_get() + drain)
	if drain > 0:
		emit_signal("drained_mp", drain)
	emit_signal("turn_start")

func end_turn():
	emit_signal("turn_end")

func get_stat_val(stat: String):
	return max(_gather_inlfuencers(stat), 1)

func get_manager():
	return $"/root/Root/Combat"

func _gather_inlfuencers(stat: String, node: Node = self):
	var res = 0
	for i in node.get_children():
		res += _gather_inlfuencers(stat, i)
	
	if node is Influencer:
		if node.target_stat == stat:
			res += node.influence
	
	return res

func get_skills(node = self):
	var res = []
	for i in node.get_children():
		res = res + get_skills(i)
	
	if node is BaseSkill:
		res.append(node)
	
	return res

func get_passives(node = self):
	var res = []
	
	for i in node.get_children():
		res = res + get_passives(i)
	
	if node is BasePassiveSkill:
		res.append(node)
	
	return res

func die():
	emit_signal("died")

func send_dmg(inst: DamageInstance):
	var hitrand = (randi() % 10000)/10000.0
	var critrand = (randi() % 10000)/10000.0
	
	emit_signal("pre_determine_hit", inst)
	
	if hitrand > GUtil.teddy(inst.target.get_stat_val("AVD") - get_stat_val("HIT")) or inst.is_homing:
		if critrand < GUtil.teddy(get_stat_val("CTR")) and inst.is_able_crit:
			inst.amount *= ((get_stat_val("CTD")/100.0)+1)
			inst.did_crit = true
			emit_signal("critted", inst)
		
		emit_signal("sent_dmg", inst)
		inst.target.receive_dmg(inst)
	else:
		emit_signal("missed", inst)
		inst.target.emit_signal("dodge", inst)

func receive_dmg(inst: DamageInstance):
	emit_signal("received_dmg", inst)
	inst.emit_signal("pre_dmg_adjusted")
	if inst.dmg_type == inst.TYPE.PHYS:
		inst.amount *= (1-GUtil.teddy(get_stat_val("DEF"))*(1-inst.pierce))
	elif inst.dmg_type == inst.TYPE.MAG:
		inst.amount *= (1-GUtil.teddy(get_stat_val("AUR"))*(1-inst.pierce))
	
	emit_signal("pre_applied_dmg", inst)
	inst.emit_signal("pre_dmg_applied")
	
	if inst.dmg_type == inst.TYPE.HEAL:
		if hp > 0: # Doesn't really apply to enemies but you def should not be able to heal dead allies
			hp_set(hp_get() + inst.amount)
	else:
		hp_set(hp_get() - inst.amount)
	
	emit_signal("applied_dmg", inst)
	inst.emit_signal("dmg_applied")
