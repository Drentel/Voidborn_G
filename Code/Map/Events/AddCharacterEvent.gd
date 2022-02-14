extends MapEvent

export var soul_path = "res://Placeholders/test_soul.tres"
export var default_pact = "res://Placeholders/test_pact.tres"
export var start_level = 10
export var weapon_class = 0
export var weapon_level = 5
export var def_name = "???"

func activate():
	var chara = load("res://Scenes/CharaCard.tscn").instance()
	chara.weap = GUtil.make_weapon(weapon_level, weapon_class)
	chara.soul = soul_path
	chara.pact = default_pact
	chara.lvl = start_level
	chara.name = def_name
	if $"/root/Root".get_characters().size() < 5: # Add character as a party member
		$"/root/Root".get_character_root().add_child(chara)
		$"/root/Root".notify_party_changed()
	else:
		GPlayer.reserve_characters.append(chara)
