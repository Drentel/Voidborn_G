extends Resource

class_name EquipItem

enum TYPE {
	ARTI,
	WEAP,
}

var power = 1
var name = "Undefined item"
var item_type = TYPE.WEAP
var influence = [
	{
		"type": "stat",
		"stat": "ATK",
	},
	{
		"type": "skill",
		"skill": "res://Code/Combat/Customization/WeaponSkills/SwordWeapSkill.gd",
	},
]

func get_influences():
	var res = []
	for i in influence:
		if i["type"] == "stat":
			res.append({
				"stat": i["stat"], 
				"amount": power*GUtil.stat_weight[i["stat"]],
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
				"level": power
			})
	return res

func get_desc():
	var res = ""
	for i in influence:
		if i["type"] == "stat":
			res += i["stat"] + " + " + str(power*GUtil.stat_weight[i["stat"]]) + "\n"
		elif i["type"] == "skill":
			var nod = Node.new()
			var ski = load(i["skill"])
			nod.set_script(ski)
			res += "Grants skill: " + nod.s_name + "\n" + nod.s_desc + "\n"
	return res

func get_rank():
	return power
