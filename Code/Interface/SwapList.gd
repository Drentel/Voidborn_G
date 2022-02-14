extends Panel

func show_pacts():
	$ScrollContainer/GridContainer.columns = 2
	visible = true
	GUtil.annihilate_children($ScrollContainer/GridContainer)
	for i in GPlayer.pacts:
		var btn = ClackButton.new()
		btn.text = load(i).name
		btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
		btn.connect("pressed", self, "swap_pacts", [i])
		btn.connect("mouse_entered", Tip, "set_disp", [load(i).get_desc($"../Panel".unit.lvl)])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exiting", Tip, "hide")
		$ScrollContainer/GridContainer.add_child(btn)

func swap_pacts(pact):
	GPlayer.pacts.append($"../Panel".unit.pact)
	GPlayer.pacts.erase(pact)
	$"../Panel".unit.pact = pact
	$"../Panel".unit.unpack()
	$"../Panel".upd_vals()
	visible = false

func show_weaps():
	$ScrollContainer/GridContainer.columns = 2
	visible = true
	GUtil.annihilate_children($ScrollContainer/GridContainer)
	for i in GPlayer.equip_items:
		if i.item_type == EquipItem.TYPE.WEAP:
			var btn = ClackButton.new()
			btn.text = i.get_name()
			btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			btn.connect("pressed", self, "swap_weaps", [i])
			
			btn.connect("mouse_entered", Tip, "set_disp", [[i.get_desc()]])
			btn.connect("mouse_exited", Tip, "hide")
			btn.connect("tree_exited", Tip, "hide")
			
			$ScrollContainer/GridContainer.add_child(btn)

func swap_weaps(weap):
	visible = false
	GPlayer.equip_items.append($"../Panel".unit.weap)
	GPlayer.equip_items.erase(weap)
	$"../Panel".unit.weap = weap
	$"../Panel".unit.unpack()
	$"../Panel".upd_vals()

func show_artis(button):
	$ScrollContainer/GridContainer.columns = 3
	visible = true
	
	GUtil.annihilate_children($ScrollContainer/GridContainer)
	
	var un_btn = ClackButton.new()
	un_btn.text = "Unequip"
	un_btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
	un_btn.connect("pressed", self, "swap_artis", ["unequip", button.get_meta("arti")])
	
	$ScrollContainer/GridContainer.add_child(un_btn)
	
	for i in GPlayer.equip_items:
		if i.item_type == EquipItem.TYPE.ARTI:
			var btn = ClackButton.new()
			btn.text = i.get_name()
			btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			
			btn.connect("pressed", self, "swap_artis", [i, button.get_meta("arti")])
			
			btn.connect("mouse_entered", Tip, "set_disp", [[i.get_desc()]])
			btn.connect("mouse_exited", Tip, "hide")
			btn.connect("tree_exited", Tip, "hide")
			
			$ScrollContainer/GridContainer.add_child(btn)

func swap_artis(new, old):
	visible = false
	if new is String && old is String: #swapping nothings
		return
	elif new is String && not old is String: #unequipping
		GPlayer.equip_items.append(old)
		$"../Panel".unit.artis.erase(old)
	elif not new is String && old is String: #equipping into an empty slot
		GPlayer.equip_items.erase(new)
		$"../Panel".unit.artis.append(new)
	elif not new is String && not old is String: #swapping two artis
		GPlayer.equip_items.append(old)
		$"../Panel".unit.artis[$"../Panel".unit.artis.find(old)] = new
		GPlayer.equip_items.erase(new)
	
	$"../Panel".unit.unpack()
	$"../Panel".upd_vals()
