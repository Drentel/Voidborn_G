extends UnitBase

var dead = false
export var soul = "res://Placeholders/test_soul.tres"
export var pact = "res://Placeholders/test_pact.tres"
var weap = ""
var artis = []

var skin_dir = ""
var pos_adjust = Vector2(0,0)
var zoom_adjust = 0
var flip = false

signal selected()

func get_base_stat_val(stat: String):
	return max(_gather_inlfuencers(stat, $Unpacks), 1)

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

func get_pact():
	return load(pact)

func _ready():
	
	if weap is String:
		weap = GUtil.make_weapon(3, 0)
	
	unpack()

func unpack():
	GUtil.annihilate_children($Unpacks)
	
	for i in weap.get_skills():
		var nod = Node.new()
		nod.set_script(load(i["skill"]))
		nod.set_level(i["level"])
		$Unpacks.add_child(nod)
	
	for i in weap.get_influences():
		var inf = Influencer.new()
		inf.target_stat = i["stat"]
		inf.influence = i["amount"]
		$Unpacks.add_child(inf)
	
	var souls = [load(soul), load(pact)]
	
	for i in souls:
		
		for j in i.growth:
			var inf = Influencer.new()
			inf.target_stat = j
			inf.influence = i.get_growth(j, lvl)
			$Unpacks.add_child(inf)
		
		for j in i.skills:
			if j["req"] <= lvl:
				var nod = Node.new()
				var ski = load(j["skill"])
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
	
func get_arti_slots():
	return max(1, min((lvl+15)/15, 6))

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
