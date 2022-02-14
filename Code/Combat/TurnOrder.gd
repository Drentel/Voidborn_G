extends Control

var manager

signal order_initialized()

func _ready():
	manager = $"../"
	yield(get_tree(), "idle_frame")
	for _i in range(0, 5):
		add()
	emit_signal("order_initialized")
	get_parent().connect("enemy_died", self, "remove_unit")

func remove_unit(unit):
	for i in $VBoxContainer.get_children():
		if i.get_meta("unit") == unit:
			$VBoxContainer.remove_child(i)
			if manager.get_enemies().size() > 0:
				add()

func next():
	var next = $VBoxContainer.get_child(0).get_meta("unit")
	var childe = $VBoxContainer.get_child(0)
	$VBoxContainer.remove_child(childe)
	childe.queue_free()
	if $VBoxContainer.get_child_count() < 5:
		add()
	if next in manager.get_everyone() && next.hp > 0:
		return next
	else:
		return next()

func force_add(unit):
	# Practically exclusively used for the switch skill
	# Maybe can be used if you'll make a skill that starts a defined turn right after another
	var childe = Label.new()
	childe.text = unit.name
	childe.set_meta("unit", unit)
	childe.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	$VBoxContainer.add_child(childe)
	$VBoxContainer.move_child(childe, 0)

func add():
	# The first turn should always be an ally
	# The same unit should not act twice in a row
	# The same side should not act more than twice in a row
	
	var pool = WeightedPool.new()
	
	if $VBoxContainer.get_child_count() == 0:
		for i in manager.get_living_allies():
			pool.add(i, i.get_stat_val("SPD"))
	elif $VBoxContainer.get_child_count() == 1:
		for i in manager.get_enemies() + manager.get_living_allies():
			pool.add(i, i.get_stat_val("SPD"))
		pool.remove($VBoxContainer.get_children()[-1].get_meta("unit"))
	else:
		var allies = manager.get_living_allies()
		var enemies = manager.get_enemies()
		var last = $VBoxContainer.get_children()[-1].get_meta("unit")
		var pre_last = $VBoxContainer.get_children()[-2].get_meta("unit")
		
		if last in allies and pre_last in allies:
			for i in manager.get_enemies():
				pool.add(i, i.get_stat_val("SPD"))
		elif last in enemies and pre_last in enemies:
			for i in manager.get_living_allies():
				pool.add(i, i.get_stat_val("SPD"))
		else:
			for i in manager.get_enemies() + manager.get_living_allies():
				pool.add(i, i.get_stat_val("SPD"))
		
		pool.remove($VBoxContainer.get_children()[-1].get_meta("unit"))
	
	var lab = Label.new()
	var uni
	
	if pool.items.size() > 0:
		uni = pool.pick()
	else:
		uni = GUtil.arr_rand(manager.get_enemies() + manager.get_living_allies())
		
	lab.text = uni.name
	lab.set_meta("unit", uni)
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$VBoxContainer.add_child(lab)

func show_probs():
	$Probs/Probs.text = ""
	$Probs/Units.text = ""
	var pool = WeightedPool.new()
	for i in manager.get_enemies() + manager.get_living_allies():
		pool.add(i, i.get_stat_val("SPD"))
	
	for i in manager.get_enemies() + manager.get_living_allies():
		$Probs/Units.text += i.name + "\n"
		$Probs/Probs.text += str(int(pool.get_prob(i)*1000)/10.0) + "%\n"
	
	$Probs.rect_size.y = 32 + (($Probs/Units.get_line_count()-1)*19)
	
	$Probs.visible = true

func hide_probs():
	$Probs.visible = false

func _on_Panel_mouse_entered():
	show_probs()

func _on_Panel_mouse_exited():
	hide_probs()
