extends GridContainer

var manager

signal target_selected(target)

func _ready():
	manager = $"../../"
	hide()
	for i in manager.get_allies():
		i.connect("turn_start", self, "display_skills", [i])
		i.connect("turn_end", self, "hide")
		i.connect("nonturnend_skill_end", self, "_on_nonturnend_skill_end", [i])

func _on_nonturnend_skill_end(_skill, unit):
	display_skills(unit)

func display_skills(unit):
	hide()
	GUtil.annihilate_children(self)
	
	var echo_btn = ClackButton.new()
	echo_btn.connect("pressed", self, "display_echoes", [unit])
	echo_btn.text = "Use echo"
	echo_btn.size_flags_horizontal += echo_btn.SIZE_EXPAND
	add_child(echo_btn)
	show()
	
	for i in unit.get_skills():
		var btn = ClackButton.new()
		btn.connect("pressed", self, "skill_btn_pressed", [unit, i])
		btn.connect("mouse_entered", i, "show_desc_tip", [unit])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		btn.text = i.s_name
		btn.size_flags_horizontal += btn.SIZE_EXPAND
		if !i.check_usability(unit):
			btn.disabled = true
		add_child(btn)
	
	yield(get_tree(), "idle_frame") #Prevents single-frame flickering if old skills haven't disappeared yet
	show()

func display_echoes(unit):
	hide()
	GUtil.annihilate_children(self)
	
	for i in GPlayer.lechoes:
		var btn = ClackButton.new()
		btn.connect("pressed", self, "skill_btn_pressed", [unit, i])
		btn.connect("mouse_entered", i, "show_desc_tip", [unit])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		btn.text = i.s_name
		btn.size_flags_horizontal += btn.SIZE_EXPAND
		add_child(btn)
	
	for i in GPlayer.lused_echoes:
		var btn = ClackButton.new()
		btn.connect("mouse_entered", i, "show_desc_tip", [unit])
		btn.connect("mouse_exited", Tip, "hide")
		btn.connect("tree_exited", Tip, "hide")
		btn.text = i.s_name
		btn.size_flags_horizontal += btn.SIZE_EXPAND
		btn.disabled = true
		add_child(btn)
	
	var cancel_btn = ClackButton.new()
	cancel_btn.connect("pressed", self, "display_skills", [unit])
	cancel_btn.text = "Cancel"
	cancel_btn.size_flags_horizontal += cancel_btn.SIZE_EXPAND
	add_child(cancel_btn)
	show()

var target_btns = []

func display_targets(targets):
	hide()
	GUtil.annihilate_children(self)
	
	for i in targets:
		var btn = Button.new()
		btn.connect("pressed", self, "target_selected", [i])
		btn.modulate.a = 0.5
		btn.rect_size = i.rect_size
		btn.text = "SELECT TARGET"
		manager.add_child(btn)
		btn.rect_global_position = i.rect_global_position
		target_btns.append(btn)
	
	var cancel_btn = ClackButton.new()
	cancel_btn.connect("pressed", self, "target_selected", [0])
	cancel_btn.text = "Cancel"
	cancel_btn.size_flags_horizontal += cancel_btn.SIZE_EXPAND
	add_child(cancel_btn)
	show()

func target_selected(target):
	hide()
	for i in target_btns:
		i.visible = false
		i.queue_free()
	target_btns.clear()
	
	GUtil.annihilate_children(self)
	yield(get_tree(), "idle_frame")
	emit_signal("target_selected", target)

func skill_btn_pressed(unit, skill):
	hide()
	skill.use(unit)

func hide():
	visible = false

func show():
	visible = true
