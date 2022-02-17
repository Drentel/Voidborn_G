extends Control
class_name CombatManager

export var scenario_path: String

var scenario

var enemy_slots = []
signal enemy_died(unit)
signal combat_won()
signal combat_lost()

var name_appends = ["", " A", " B", " C", " D", " E", " F", " G"]

func _ready():
	scenario = load(scenario_path)
	
	$ManaLabel.text = str(randi() % (scenario.mana_max - scenario.mana_min) + scenario.mana_min)
	
	var counter
	
	if scenario.skip_first_name or scenario.slots.size() == 1:
		counter = 0
	else:
		counter = 1
	
	for i in scenario.slots:
		var slot = {"enemies":[], "current":0}
		for j in i["enemies"]:
			var enemy = load(j).instance()
			enemy.name += name_appends[counter]
			slot["enemies"].append(enemy)
			enemy.rect_position = i["pos"]
		
		slot["current"] = slot["enemies"].pop_front()
		$Enemies.add_child(slot["current"])
		slot["current"].connect("died", self, "on_enemy_died", [slot])
		slot["current"].connect("died", self, "on_unit_died", [slot["current"]])
		slot["current"].emit_signal("entered_combat")
		counter += 1
	
	if scenario.first_is_enough:
		enemy_slots[0]["current"].connect("died", self, "combat_win")
	
	yield(get_turn_order(), "order_initialized")
	
	var hig = load("res://Scenes/HighlightControl.tscn").instance()
	hig.visible = false
	add_child(hig)
	
	for i in get_allies():
		i.connect("died", self, "on_unit_died", [i])
		i.emit_signal("entered_combat")
	
	while true:
		if get_enemies().size() == 0:
			combat_win()
			return
		
		if get_living_allies().size() == 0:
			combat_lose()
			return
		
		var uni = get_turn_order().next()
		uni.start_turn()
		if uni in get_allies():
			hig.rect_size = uni.rect_size
			hig.rect_global_position = uni.rect_global_position
			hig.visible = true
		else:
			hig.visible = false
		yield(uni, "turn_end")

func get_field_mana():
	return int($ManaLabel.text)

func set_field_mana(num):
	$ManaLabel.text = str(num)

func on_unit_died(unit):
	set_field_mana(get_field_mana() + unit.mp_get())
	unit.mp_set(0)

func on_enemy_died(slot):
	var enmy = slot["current"]
	if slot["enemies"].size() > 0:
		slot["current"] = slot["enemies"].pop_front()
		$Enemies.add_child(slot["current"])
		slot["current"].connect("died", self, "on_enemy_died", [slot])
		slot["current"].connect("died", self, "on_unit_died", [slot["current"]])
	
	emit_signal("enemy_died", enmy)

func combat_win():
	emit_signal("combat_won")
	$FadeAnim.play("FadeAnim")
	for i in get_allies():
		i.emit_signal("exited_combat")
		for j in i.get_statuses():
			j.get_parent().remove_child(j)
			j.queue_free()
		
	yield($FadeAnim, "animation_finished")
	queue_free()

func combat_lose():
	emit_signal("combat_lost")
	$FadeAnim.play("FadeAnim")
	for i in get_allies():
		i.emit_signal("exited_combat")
		for j in i.get_statuses():
			j.get_parent().remove_child(j)
			j.queue_free()
		
	yield($FadeAnim, "animation_finished")
	GPlayer.respawn()
	queue_free()

const ally_target_probs = [45, 25, 15, 10, 5]
func get_ally_target_pool():
	var count = 0
	var pool = WeightedPool.new()
	for i in $"../CharaCards".get_children():
		if not i.dead:
			pool.add(i, ally_target_probs[count])
		count += 1
	return pool

func get_living_allies():
	var res = []
	for i in get_allies():
		if not i.dead:
			res.append(i)
	return res

func get_allies():
	return $"../CharaCards".get_children()

func get_enemies():
	return $Enemies.get_children()

func get_everyone():
	return get_allies() + get_enemies()

func get_controls():
	return $Controls/Controls

func get_turn_order():
	return $TurnOrder
