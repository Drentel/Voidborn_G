extends UnitBase
class_name AllyUnit

var dead = false
export var soul = "res://Placeholders/test_soul.tres"
var weap = ""
var artis = []
export var equip_skills = []
var attunement = {
	"earth": 0,
	"fire": 0,
	"air": 0,
	"water": 0,
}

const attunement_binds = {
	"earth": ["DEF", "AUR", "MHP"],
	"fire": ["ATK", "CRM", "CTD"],
	"air": ["CTR", "SPD", "AVD"],
	"water": ["TEC", "ABS", "HIT"],
}

const attunement_power = 3

var skin_dir = ""
var pos_adjust = Vector2(0,0)
var zoom_adjust = 0
var flip = false

signal selected()
signal unpacked()

func get_base_stat_val(stat: String):
	return max(_gather_inlfuencers(stat, $Unpacks), 1)

func get_attunement_pts():
	var points = lvl/5
	
	for i in attunement.values():
		points -= i
	
	return points

func set_skin(path: String):
	skin_dir = path
	if File.new().file_exists(skin_dir + "/portrait.json"):
		var js = GUtil.objectify_json(skin_dir + "/portrait.json")
		$Ava.texture = GUtil.texturize_path(skin_dir + js["avatar"])
		if "offset_x" in js.keys():
			pos_adjust.x = js["offset_x"]
		else:
			pos_adjust.x = 0
		if "offset_y" in js.keys():
			pos_adjust.y = js["offset_y"]
		else:
			pos_adjust.y = 0
		if "zoom" in js.keys():
			zoom_adjust = js["zoom"]
		else:
			zoom_adjust = 0
		if "flip" in js.keys():
			flip = js["flip"]
		else:
			flip = false
		
		emit_signal("selected")

func get_soul():
	return load(soul)

func _ready():
	if weap is String:
		weap = GUtil.make_weapon(3, 0)
	
	unpack()

func unpack():
	GUtil.annihilate_children($Unpacks)
	
	for i in weap.get_skills():
		$Unpacks.add_child(load(i["skill"]).new())
	
	for i in weap.get_influences():
		var inf = Influencer.new()
		inf.target_stat = i["stat"]
		inf.influence = i["amount"]
		$Unpacks.add_child(inf)
	
	var l_soul = load(soul)
	
	for i in attunement.keys():
		if attunement[i] > 0:
			for j in attunement_binds[i]:
				var inf = Influencer.new()
				inf.target_stat = j
				inf.influence = attunement[i]*attunement_power*GUtil.stat_weight[j]
				$Unpacks.add_child(inf)
	
	for i in l_soul.growth:
		var inf = Influencer.new()
		inf.target_stat = i
		inf.influence = l_soul.get_growth(i, lvl)
		$Unpacks.add_child(inf)
	
	for i in l_soul.skills:
		if i["req"] <= lvl:
			var nod = Node.new()
			var ski = load(i["skill"])
			nod.set_script(ski)
			$Unpacks.add_child(nod)
	
	for i in equip_skills:
		var nod = Node.new()
		var ski = load(i)
		nod.set_script(ski)
		$Unpacks.add_child(nod)
	
	for i in artis:
		for j in i.get_skills():
			var util = false
			var scr = load(j["skill"])
			for q in $Unpacks.get_children():
				if q.script == scr:
					q.set_level(q.level + j["level"])
					util = true
			
			if not util:
				var nod = Node.new()
				nod.set_script(scr)
				nod.set_level(j["level"])
				$Unpacks.add_child(nod)
		
		for j in i.get_influences():
			var inf = Influencer.new()
			inf.target_stat = j["stat"]
			inf.influence = j["amount"]
			$Unpacks.add_child(inf)
			
	hp_set(get_stat_val("MHP"))
	mp_set(get_stat_val("MMP"))
	
	emit_signal("unpacked")

func get_arti_slots():
	return min((lvl+15)/15, 6)

func get_skill_slots():
	return min((lvl+15)/15, 6)+load(soul).bonus_skill_slots

func die():
	.die()
	dead = true

func revive():
	dead = false
	hp_set(1)

func start_turn():
	.start_turn()
	emit_signal("selected")
	if dead:
		end_turn()
