extends Panel
var unit
var arti_buttons = ButtonGroup.new()

func _ready():
	unit = $"/root/Root".get_characters()[0]
	unit.connect("selected", self, "upd_vals")
	unit.emit_signal("selected")
	$WeaponButton.connect("mouse_exited", Tip, "hide")
	$WeaponButton.connect("tree_exited", Tip, "hide")
	arti_buttons.connect("pressed", get_parent().get_node("SwapList"), "show_artis")
	
	for i in $"/root/Root".get_characters():
		var btn = ClackButton.new()
		btn.connect("pressed", self, "_on_CharaSelected", [i])
		btn.modulate.a = 0.1
		$"../CharaSelect".add_child(btn)
		btn.rect_global_position = i.rect_global_position
		btn.rect_size = i.rect_size


func upd_vals():
	$PosAdj.disabled = unit.skin_dir == ""
	
	$MainInfo/CharaName.text = unit.name
	$MainInfo/LevelInfo.text = "LEVEL " + str(unit.lvl)
	
	
	
	
	$MainInfo/SoulName.text = unit.get_soul().name
	GUtil.safe_connect($MainInfo/SoulName, "mouse_entered", Tip, "set_disp", [unit.get_soul().get_desc(unit.lvl)])
	GUtil.safe_connect($MainInfo/SoulName, "mouse_exited", Tip, "hide")
	GUtil.safe_connect($MainInfo/SoulName, "tree_exited", Tip, "hide")
	#$MainInfo/SoulName.connect("mouse_entered", Tip, "set_disp", [unit.get_soul().get_desc(unit.lvl)])
	#$MainInfo/SoulName.connect("mouse_exited", Tip, "hide")
	#$MainInfo/SoulName.connect("tree_exited", Tip, "hide")
	
	$PactButton.text = load(unit.pact).name
	GUtil.safe_connect($PactButton, "mouse_entered", Tip, "set_disp", [load(unit.pact).get_desc(unit.lvl)])
	GUtil.safe_connect($PactButton, "mouse_exited", Tip, "hide")
	GUtil.safe_connect($PactButton, "tree_exited", Tip, "hide")
	#$PactButton.connect("mouse_entered", Tip, "set_disp", [load(unit.pact).get_desc(unit.lvl)])
	#$PactButton.connect("mouse_exited", Tip, "hide")
	#$PactButton.connect("tree_exited", Tip, "hide")
	
	
	
	
	GUtil.annihilate_children($MainInfo/StatValues)
	for i in GUtil.stat_definitions:
		var st = Label.new()
		st.align = Label.ALIGN_CENTER
		if i in GUtil.teddy_definitions:
			st.text = str(unit.get_stat_val(i))
			st.text += "(" + str(ceil(1000*GUtil.teddy(unit.get_stat_val(i)))/10.0) + "%)"
		else:
			st.text = str(unit.get_stat_val(i))
		$MainInfo/StatValues.add_child(st)
	
	
	GUtil.annihilate_children($SkillContainer/GridContainer)
	var display_skills = unit.get_skills() + unit.get_passives()
	for i in display_skills:
		var btn = ClackButton.new()
		btn.text = i.s_name
		btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
		
		btn.connect("mouse_entered", Tip, "set_disp", [[i.s_desc]])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		
		$SkillContainer/GridContainer.add_child(btn)
	
	$WeaponButton.text = unit.weap.get_name()
	
	GUtil.safe_connect($WeaponButton, "mouse_entered", Tip, "set_disp", [[unit.weap.get_desc()]])
	#$WeaponButton.connect("mouse_entered", Tip, "set_disp", [[unit.weap.get_desc()]])
	
	GUtil.annihilate_children($ArtifactSlots)
	for i in unit.artis:
		var btn = ClackButton.new()
		btn.text = i.get_name()
		btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
		
		btn.connect("mouse_entered", Tip, "set_disp", [[i.get_desc()]])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		
		btn.toggle_mode = true
		btn.group = arti_buttons
		
		btn.set_meta("arti", i)
		
		$ArtifactSlots.add_child(btn)
	
	if $ArtifactSlots.get_child_count() < unit.get_arti_slots():
		for _i in range(unit.get_arti_slots() - $ArtifactSlots.get_child_count()):
			var btn = ClackButton.new()
			btn.text = "artifact slot"
			
			btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			
			btn.toggle_mode = true
			btn.group = arti_buttons
			
			btn.set_meta("arti", "none")
			
			$ArtifactSlots.add_child(btn)
	
	$"../SwapList".visible = false

func _on_CharaSelected(chara):
	unit.disconnect("selected", self, "upd_vals")
	unit = chara
	unit.connect("selected", self, "upd_vals")
	unit.emit_signal("selected")
