extends Panel
var unit
var arti_buttons = ButtonGroup.new()
var skill_buttons = ButtonGroup.new()

func _ready():
	unit = $"/root/Root".get_characters()[0]
	unit.connect("selected", self, "upd_vals")
	unit.emit_signal("selected")
	$TabContainer/Gear/WeaponButton.connect("mouse_exited", Tip, "hide")
	$TabContainer/Gear/WeaponButton.connect("tree_exited", Tip, "hide")
	arti_buttons.connect("pressed", get_parent().get_node("SwapList"), "show_artis")
	arti_buttons.connect("pressed", self, "unselect_btn")
	
	skill_buttons.connect("pressed", get_parent().get_node("SwapList"), "show_skills")
	skill_buttons.connect("pressed", self, "unselect_btn")
	
	for i in $"/root/Root".get_characters():
		var btn = ClackButton.new()
		btn.connect("pressed", self, "_on_CharaSelected", [i])
		btn.modulate.a = 0.1
		$"../CharaSelect".add_child(btn)
		btn.rect_global_position = i.rect_global_position
		btn.rect_size = i.rect_size

func unselect_btn(button):
	button.pressed = false

func upd_vals():
	$PosAdj.disabled = unit.skin_dir == ""
	
	$MainInfo/CharaName.text = unit.name
	$MainInfo/LevelInfo.text = "LEVEL " + str(unit.lvl)
	
	$MainInfo/SoulName.text = unit.get_soul().name
	GUtil.safe_connect($MainInfo/SoulName, "mouse_entered", Tip, "set_disp", [unit.get_soul().get_desc(unit.lvl)])
	GUtil.safe_connect($MainInfo/SoulName, "mouse_exited", Tip, "hide")
	GUtil.safe_connect($MainInfo/SoulName, "tree_exited", Tip, "hide")
	
	GUtil.annihilate_children($MainInfo/StatValues)
	for i in GUtil.stat_definitions:
		var st = Label.new()
		st.align = Label.ALIGN_CENTER
		if i in GUtil.teddy_definitions:
			st.text = str(unit.get_stat_val(i))
			st.text += "(" + str(GUtil.disp_decim(GUtil.teddy(unit.get_stat_val(i))*100)) + "%)"
		else:
			st.text = str(unit.get_stat_val(i))
		$MainInfo/StatValues.add_child(st)
	
	
	GUtil.annihilate_children($SkillContainer/GridContainer)
	var display_skills = unit.get_skills() + unit.get_passives()
	for i in display_skills:
		var btn = ClackButton.new()
		btn.text = i.s_name
		btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
		
		#btn.connect("mouse_entered", Tip, "set_disp", [[i.s_desc]])
		btn.connect("mouse_entered", i, "show_desc_tip", [unit])
		
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		
		$SkillContainer/GridContainer.add_child(btn)
	
	$TabContainer/Gear/WeaponButton.text = unit.weap.get_name()
	
	GUtil.safe_connect($TabContainer/Gear/WeaponButton, "mouse_entered", Tip, "set_disp", [[unit.weap.get_desc()]])
	
	GUtil.annihilate_children($TabContainer/Gear/ArtifactSlots)
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
		
		$TabContainer/Gear/ArtifactSlots.add_child(btn)
	
	if $TabContainer/Gear/ArtifactSlots.get_child_count() < unit.get_arti_slots():
		for _i in range(unit.get_arti_slots() - $TabContainer/Gear/ArtifactSlots.get_child_count()):
			var btn = ClackButton.new()
			btn.text = "artifact slot"
			
			btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			
			btn.toggle_mode = true
			btn.group = arti_buttons
			
			btn.set_meta("arti", "none")
			
			$TabContainer/Gear/ArtifactSlots.add_child(btn)
	
	
	GUtil.annihilate_children($TabContainer/Skills/SkillSlots)
	for i in unit.equip_skills:
		var l_skill = load(i).new()
		var btn = ClackButton.new()
		btn.text = l_skill.s_name
		btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
		
		btn.connect("mouse_entered", Tip, "set_disp", [[l_skill.s_desc]])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		
		btn.toggle_mode = true
		btn.group = skill_buttons
		
		btn.set_meta("skill", i)
		
		$TabContainer/Skills/SkillSlots.add_child(btn)
	
	if $TabContainer/Skills/SkillSlots.get_child_count() < unit.get_skill_slots():
		for _i in range(unit.get_arti_slots() - $TabContainer/Skills/SkillSlots.get_child_count()):
			var btn = ClackButton.new()
			btn.text = "skill slot"
			
			btn.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			
			btn.toggle_mode = true
			btn.group = skill_buttons
			
			btn.set_meta("skill", "none")
			
			$TabContainer/Skills/SkillSlots.add_child(btn)
	
	
	$"../SwapList".hide()
	$TabContainer/Attunement.unpack()

func _on_CharaSelected(chara):
	unit.disconnect("selected", self, "upd_vals")
	unit = chara
	unit.connect("selected", self, "upd_vals")
	unit.emit_signal("selected")
