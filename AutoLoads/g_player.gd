extends Node

var settings = {
	"SFX_VOL": -18,
	"MUS_VOL": -18,
}

var flags = {}
var generic_items = {}
var equip_items = []
var money = 1000 setget money_set
var respawn_loc = "res://Scenes/Maps/Level1.tscn"
var respawn_node = "Fountain"
var reserve_characters = []
var skills = []

signal money_changed(oldval)

func money_set(am):
	var oldval = money
	money = am
	emit_signal("money_changed", oldval)

func get_item(item_name):
	if item_name in generic_items:
		return generic_items[item_name]
	else:
		return 0

func _ready():
	skills += [
		"res://Code/Combat/Customization/Skills/LeaderPact/MoralSupport.gd",
		"res://Code/Combat/Customization/Skills/LeaderPact/Rally.gd",
		"res://Code/Combat/Customization/Skills/LeaderPact/Transfer.gd",
		"res://Code/Combat/Customization/Skills/Passives/CritChance.gd",
		"res://Code/Combat/Customization/Skills/Passives/CritDamage.gd",
		"res://Code/Combat/Customization/Skills/Passives/HomingChance.gd",
		"res://Code/Combat/Customization/Skills/Passives/OverhealBarrier.gd",
		"res://Code/Combat/Customization/Skills/Passives/PierceAdd.gd",
		"res://Code/Combat/Customization/Skills/Passives/Regen.gd",
	]

func respawn():
	for i in $"/root/Root/CharaCards".get_children():
		i.hp_set(i.get_stat_val("MHP"))
		i.mp_set(i.get_stat_val("MMP"))
		i.dead = false
	$"/root/Root".force_map_switch(respawn_loc, respawn_node)
