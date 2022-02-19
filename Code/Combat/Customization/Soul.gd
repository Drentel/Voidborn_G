extends Resource
class_name Soul
# Every stat should be included, even if 0
# Numbers are amount added every level
export var growth = {
	"MHP": 1.0, 
	"MMP": 0.0, 
	"ATK": 1.0, 
	"CRM": 1.0, 
	"TEC": 1.0, 
	"DEF": 1.0, 
	"AUR": 1.0, 
	"CTR": 1.0, 
	"CTD": 1.0, 
	"SPD": 1.0, 
	"HIT": 1.0, 
	"AVD": 1.0, 
	"ABS": 1.0,
}

export var base = {
	"MHP": 0, 
	"MMP": 50, 
	"ATK": 0, 
	"CRM": 0, 
	"TEC": 0, 
	"DEF": 0, 
	"AUR": 0, 
	"CTR": 0, 
	"CTD": 0, 
	"SPD": 0, 
	"HIT": 0, 
	"AVD": 0, 
	"ABS": 0,
}

export(String, "Soul", "Pact") var type = "Soul"

export var skills = [{"skill": "res://Code/Combat/Customization/Skills/BaseSkill.gd", "req":0}]

export var name: String
export var shortname: String

func get_growth(stat: String, lvl: int):
	return ceil((growth[stat]*lvl) + base[stat])

func get_desc(lvl):
	var res = []
	var desc = ""
	for i in GUtil.stat_definitions:
		var val = ceil((growth[i]*lvl) + base[i])
		if val > 0:
			desc += i + " + " + str(val) + "\n"
	res.append(desc)
	
	for i in skills:
		var comp = ""
		comp += "Granted at level " + str(i["req"]) + ":\n"
		var nod = Node.new()
		nod.set_script(load(i["skill"]))
		comp += nod.s_name + "\n"
		comp += nod.s_desc
		res.append(comp)
	
	return res
