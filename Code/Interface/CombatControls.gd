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
	for i in unit.get_skills():
		var btn = ClackButton.new()
		btn.connect("pressed", self, "skill_btn_pressed", [unit, i])
		#btn.connect("mouse_entered", Tip, "set_disp", [[i.s_desc]])
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
