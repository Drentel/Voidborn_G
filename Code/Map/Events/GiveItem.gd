extends MapEvent

export var loot_table = "res://Placeholders/placeholder_loot.tres"
export var table_single = ""
export var repeat = 1


func activate():
	var tab = load(loot_table)
	var actual_repeats = repeat
	var tab2
	if table_single != "":
		tab2 = load(table_single)
		actual_repeats += 1
	var tot_makka = 0
	var tot_weaps = []
	var tot_artis = []
	var tot_generics = {}
	
	for i in range(repeat):
		var res
		if i == 0 and table_single != "":
			res = tab2.generate()
		else:
			res = tab.generate()
		
		for j in res:
			if j["type"] == "money":
				var am = randi()%int(j["amount_max"] - j["amount_min"]+1) + j["amount_min"]
				GPlayer.money_set(am + GPlayer.money)
				Curtain.ln("Got " + str(am) + " makka")
				tot_makka += am
			elif j["type"] == "artifact":
				var power = randi()%int(j["power_max"] - j["power_min"]+1) + j["power_min"]
				var art = GUtil.make_arti(power)
				GPlayer.equip_items.append(art)
				Curtain.ln("Got an artifact: " + art.get_name())
				tot_artis.append("Artifact: " + art.get_name())
			elif j["type"] == "weapon":
				var power = randi()%int(j["power_max"] - j["power_min"]+1) + j["power_min"]
				var weap = GUtil.make_weapon(power)
				GPlayer.equip_items.append(weap)
				Curtain.ln("Got a weapon: " + weap.get_name())
				tot_weaps.append("Weapon: " + weap.get_name())
			elif j["type"] == "generic":
				var amount = randi()%int(j["amount_max"] - j["amount_min"]+1) + j["amount_min"]
				if j["name"] in GPlayer.generic_items:
					GPlayer.generic_items[j["name"]] += amount
				else:
					GPlayer.generic_items[j["name"]] = amount
				Curtain.ln("Got " + str(amount) + "x " + j["name"])
				if j["name"] in tot_generics:
					tot_generics[j["name"]] += amount
				else:
					tot_generics[j["name"]] = amount
	var tot = ""
	if tot_makka > 0:
		tot += str(tot_makka) + " makka\n"
	for i in tot_weaps + tot_artis:
		tot += i + "\n"
	
	for i in tot_generics.keys():
		tot += str(tot_generics[i]) + "x " + i + "\n"
	
	$"/root/Root".switch_loot(tot)
	.activate()
