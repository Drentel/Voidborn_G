extends Node

# "Dummy" stats are stats that do not have any effect by themselves
# These stats exist only for abilities to scale off of

# "Teddy" stats are those that are converted into a 0~95% value before taking an effect
# Check the teddy function in this class for details

const stat_definitions = {
	"MHP":"Maximum HP. The character dies if it runs out.",
	"MMP":"Maximum MP. Some abilities use up MP to activate. MP-costing abilities can be used if the character doesn't have enough, but in this case HP will be consumed, at a 20 HP to 1 point of MP conversion.",
	"ATK":"Most physical attacks scale off this stat",
	"CRM":"Most magical attacks scale off this stat",
	"TEC":"Most miscelaneous abilities, like healing and buffing/debuffing scale off this stat",
	"DEF":"Physical damage reduction. The % is the amount by which incoming damage will be reduced. High values offer diminishing returns.",
	"AUR":"Magical damage reduction. The % is the amount by which incoming damage will be reduced. High values offer diminishing returns.",
	"CTR":"Chance at which critical hits happen. High values offer diminishing returns",
	"CTD":"Damage multiplier of critical hits. Every point is a 1% increase in damage",
	"SPD":"Faster characters take turns more often, on average. A character with double the speed will act about twice as often",
	"HIT":"Accuracy of attacks. High HIT helps offset target AVD",
	"AVD":"Gives a chance to fully avoid an incoming attack. The actual chance will be lower most of the time because of attacker HIT",
	"ABS":"The % of battlefield mana that will be absorbed at the start of turn",
}

const teddy_definitions = [
	"DEF",
	"AUR",
	"CTR",
	"AVD",
	"ABS",
]

const stat_weight = {
	"MHP":10,
	"MMP":1,
	"ATK":1,
	"CRM":1,
	"TEC":1,
	"DEF":1,
	"AUR":1,
	"CTR":1,
	"CTD":1,
	"SPD":1,
	"HIT":1,
	"AVD":1,
	"ABS":1,
}

var precalc_teddies = [0.0]

var connections = []
func safe_connect(source, event, receiver, method, additions = []):
	if [source, event, receiver, method] in connections:
		source.disconnect(event, receiver, method)
	else:
		connections.append([source, event, receiver, method])
	
	if additions == []:
		source.connect(event, receiver, method)
	else:
		source.connect(event, receiver, method, additions)

func _teddy_precalc():
	var res = 0.0
	for _i in range(0, 10000):
		res += (1.0-res)/100
		precalc_teddies.append(res*0.95)

func teddy(stat_val: int):
	if stat_val < 1:
		return 0.01
	elif stat_val < 10000:
		return precalc_teddies[stat_val]
	else:
		return 0.95

func _ready():
	_teddy_precalc()
	randomize()

func arr_rand(arr):
	return arr[randi() % arr.size()]

func arr_swap(arr, obj1, obj2):
	var idx1 = arr.find(obj1)
	var idx2 = arr.find(obj2)
	arr.erase(obj2)
	arr.insert(idx1, obj2)
	arr.erase(obj1)
	arr.insert(idx2, obj1)

func annihilate_children(node: Node):
	for i in node.get_children():
		i.get_parent().remove_child(i)
		i.queue_free()

func soft_annihilate_children(node: Node):
	for i in node.get_children():
		i.get_parent().remove_child(i)

var texturization_cache = {}

func texturize_path(path: String):
	if !path in texturization_cache:
		var image = Image.new()
		image.load(path)
		var t = ImageTexture.new()
		t.create_from_image(image)
		texturization_cache[path] = t
		return t
	else:
		return texturization_cache[path]

func objectify_json(path: String):
	var file = File.new()
	file.open(path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

var weapon_skills = [
	"res://Code/Combat/Customization/Skills/WeaponSkills/SwordWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/BellWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/ClaymoreWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/RapierWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/ScytheWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/WandWeapSkill.gd",
	"res://Code/Combat/Customization/Skills/WeaponSkills/CatalystWeapSkill.gd",
]

func make_weapon(power: int, override = -1):
	var ite = EquipItem.new()
	ite.influence = []
	ite.item_type = EquipItem.TYPE.WEAP
	ite.power = power
	
	var ski
	if override == -1:
		ski = GUtil.arr_rand(weapon_skills)
	else:
		ski = weapon_skills[override]
	
	ite.influence.append({
		"type": "skill",
		"skill": ski,
	})
	
	var lski = load(ski).new()
	#lski.set_script(load(ski))
	
	ite.influence.append({
		"type": "stat",
		"stat": GUtil.arr_rand(lski.possible_stats),
	})
	
	while ite.get_rank() < power:
		GUtil.arr_rand(ite.influence)["points"] += 1
	
	ite.name = gen_weap_name(lski.item_base_name)
	
	return ite

var artifact_skills = [
	"res://Code/Combat/Customization/ArtiSkills/ArtiRegen.gd",
	"res://Code/Combat/Customization/ArtiSkills/ArtiCritChance.gd",
	"res://Code/Combat/Customization/ArtiSkills/ArtiCritDamage.gd",
	"res://Code/Combat/Customization/ArtiSkills/ArtiOverhealBarrier.gd",
	"res://Code/Combat/Customization/ArtiSkills/ArtiHomingChance.gd",
]

func make_arti(power: int):
	var ite = EquipItem.new()
	ite.influence = []
	ite.item_type = EquipItem.TYPE.ARTI
	ite.power = power
	
	#80% of artifacts give a stat. The other 20% giev an ability
	if randi()%5 == 0:
		#Ability artifact
		ite.influence.append({
			"type": "skill",
			"skill": arr_rand(artifact_skills),
		})
	else:
		#Stat artifact
		ite.influence.append({
			"type": "stat",
			"stat": arr_rand(stat_definitions.keys()),
		})
	
	ite.name = gen_arti_name()
	return ite

var prefixes = [
	"Wooden ",
	"Iron ",
	"Copper ",
	"Golden ",
	"Steel ",
	"Diabolical ",
	"The ",
	"Wunder ",
	"Diamond ",
	"Maple ",
	"Sleek ",
	"Menancing ",
	"Omni-",
	"Hyper-",
	"Mega-",
	"Ultimate ",
	"Holy ",
	"Pelmenium ",
	"Platinum ",
	"Silver ",
	"Meaty ",
	"Guardian's ",
	"Angel's ",
	"Heroic ",
	"Ivory ",
	"Gay ",
	"Supreme ",
	"Sticky ",
	"Floppy ",
	]

var postfixes = [
	"inator",
	" of Love",
	"blade",
	" Machine",
	" EX",
	"fish",
	" of Destruction",
	" of Annihilation",
]

func gen_weap_name(base):
	var postrand = randi()%100
	var name = ""
	
	if postrand < 60:
		name = arr_rand(prefixes) + base
	if postrand < 80:
		name = base + GUtil.arr_rand(postfixes)
	else:
		name = arr_rand(prefixes) + base + arr_rand(postfixes)
	
	if name.length() > 25:
		return gen_weap_name(base)
	else:
		return name

var atifact_bases = [
	"Rack",
	"Pendant",
	"Ring",
	"Goop",
	"Bracelet",
	"Fork",
	"Spoon",
	"Necklace",
	"Hairpin",
	"Needle",
	"Charm",
	"Seal",
]

func gen_arti_name():
	var postrand = randi()%100
	var name = ""
	
	if postrand < 60:
		name = arr_rand(prefixes) + arr_rand(atifact_bases)
	if postrand < 80:
		name = arr_rand(atifact_bases) + arr_rand(postfixes)
	else:
		name = arr_rand(prefixes) + arr_rand(atifact_bases) + GUtil.arr_rand(postfixes)
	
	if name.length() > 15:
		return gen_arti_name()
	else:
		return name
