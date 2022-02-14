extends Resource

class_name EquipItem

enum TYPE {
	ARTI,
	WEAP,
}

var name = "Undefined item"
var item_type = TYPE.WEAP
var influence = [
	{
		"type": "stat",
		"points": 3,
		"stat": "ATK",
	},
	{
		"type": "skill",
		"points": 1,
		"skill": "res://Code/Combat/Customization/WeaponSkills/SwordWeapSkill.gd",
	},
]

func get_influences():
	var res = []
	for i in influence:
		if i["type"] == "stat":
			res.append({
				"stat": i["stat"], 
				"amount": i["points"]*GUtil.stat_weight[i["stat"]],
			})
	return res

func get_name():
	return name + " +" + str(get_rank())

func get_skills():
	var res = []
	for i in influence:
		if i["type"] == "skill":
			res.append({
				"skill": i["skill"],
				"level": i["points"]
			})
	return res

func get_desc():
	var res = ""
	for i in influence:
		if i["type"] == "stat":
			res += i["stat"] + " + " + str(i["points"]*GUtil.stat_weight[i["stat"]]) + "\n"
		elif i["type"] == "skill":
			var nod = Node.new()
			var ski = load(i["skill"])
			nod.set_script(ski)
			nod.set_level(i["points"]) 
			res += "Grants skill: " + nod.s_name + "\n" + nod.s_desc + "\n"
	return res

func get_rank():
	var tot = 0
	for i in influence:
		tot += i["points"]
	
	return tot
