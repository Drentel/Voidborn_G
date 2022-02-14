extends Control

const map_order = [
	"Background",
	"DimSeparator",
	"CharaBust",
	"CharaCards",
	"MapScene",
	"HelpButton",
	"CharaSwitchBtn",
]

const combat_order = [
	"CharaSwitchBtn",
	"Background",
	"MapScene",
	"DimSeparator",
	"CharaBust",
	"CharaCards",
	"Combat",
	"HelpButton",
]

const edit_order = [
	"CharaSwitchBtn",
	"Background",
	"MapScene",
	"DimSeparator",
	"HelpButton",
	"CharaBust",
	"CharaCards",
	"EditScene",
]

const dialogue_order = [
	"CharaSwitchBtn",
	"Background",
	"MapScene",
	"CharaCards",
	"CharaBust",
	"DimSeparator",
	"Dialogue",
	"HelpButton",
]

const party_edit_order = [
	"CharaSwitchBtn",
	"Background",
	"HelpButton",
	"MapScene",
	"CharaBust",
	"DimSeparator",
	"CharaCards",
	"PartyEdit",
]

const loot_order = [
	"Background",
	"DimSeparator",
	"CharaBust",
	"CharaCards",
	"MapScene",
	"HelpButton",
	"CharaSwitchBtn",
	"LootDisp",
]

var shake_duration = 0

func screen_shake(duration):
	shake_duration = duration

func _ready():
	notify_party_changed()

func _process(delta):
	if shake_duration > 0:
		shake_duration -= delta
		rect_position = Vector2(randi()%4-2, randi()%4-2)
	else:
		rect_position = Vector2(0, 0)

func notify_party_changed():
	$CharaBust.rebind()
	
	yield(get_tree(), "idle_frame")
	GUtil.annihilate_children($CharaSwitchBtn)
	for i in $CharaCards.get_children():
		var btn = ClackButton.new()
		btn.connect("pressed", $CharaBust, "unit_selected", [i])
		$CharaSwitchBtn.add_child(btn)
		btn.rect_global_position = i.get_node("Label").rect_global_position
		btn.rect_size = i.get_node("Label").rect_size
		btn.modulate = Color.transparent

func get_character_root():
	return $CharaCards

func get_characters():
	return $CharaCards.get_children()

func get_map_root():
	return $MapScene

func get_living_characters():
	var res = []
	for i in get_characters():
		if i.dead:
			pass
		else:
			res.append(i)
	return res

func get_bust():
	return $CharaBust

func get_combat():
	return $Combat

func get_scenes_root():
	return self

func switch_party_edit():
	var edi = preload("res://Scenes/PartyEdit.tscn").instance()
	add_child(edi)
	order(party_edit_order)
	edi.connect("tree_exited", self, "switch_map")
	$DimSeparator.visible = true

func switch_combat(var scenario: String):
	var cmbt = preload("res://Scenes/Combat.tscn").instance()
	cmbt.scenario_path = scenario
	add_child(cmbt)
	order(combat_order)
	cmbt.connect("tree_exited", self, "switch_map")
	$DimSeparator.visible = true
	return cmbt

func switch_edit():
	var edi = preload("res://Scenes/EditScene.tscn").instance()
	add_child(edi)
	order(edit_order)
	edi.connect("tree_exited", self, "switch_map")
	$DimSeparator.visible = true
	return edi

func switch_loot(stuff):
	var loot = preload("res://Scenes/LootDisp.tscn").instance()
	add_child(loot)
	order(loot_order)
	loot.disp_stuff(stuff)
	loot.connect("tree_exited", self, "switch_map")
	return loot

func force_map_switch(location, node):
	switch_map()
	$MapScene.root.switch_map(location, node)

func switch_map():
	order(map_order)
	$DimSeparator.visible = false

func switch_dialogue(dialogue_path = "res://Dialogue/Area1/test.json"):
	var dia = load("res://Scenes/Dialogue.tscn").instance()
	dia.DialogueJson = dialogue_path
	add_child(dia)
	order(dialogue_order)
	dia.connect("tree_exited", self, "switch_map")
	$DimSeparator.visible = true
	return dia

func order(ordr):
	for i in ordr:
		move_child(get_node(i), ordr.find(i))
