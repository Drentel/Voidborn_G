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

var echoes = [
	"res://Code/Combat/Customization/Skills/Actives/Bloodletting.gd",
	"res://Code/Combat/Customization/Skills/Actives/Chainstrike.gd",
	"res://Code/Combat/Customization/Skills/Actives/Rally.gd",
	"res://Code/Combat/Customization/Skills/Actives/Reinforce.gd",
]

var lechoes = []
var lused_echoes = []

var skill_pool = [
	"res://Code/Combat/Customization/Skills/Actives/Bloodletting.gd",
	"res://Code/Combat/Customization/Skills/Actives/Chainstrike.gd",
	"res://Code/Combat/Customization/Skills/Actives/Rally.gd",
	"res://Code/Combat/Customization/Skills/Actives/Reinforce.gd",
	"res://Code/Combat/Customization/Skills/Actives/Sharpen.gd",
	"res://Code/Combat/Customization/Skills/Actives/Shred.gd",
	"res://Code/Combat/Customization/Skills/Actives/Firebolt.gd",
	"res://Code/Combat/Customization/Skills/Passives/CritChance.gd",
	"res://Code/Combat/Customization/Skills/Passives/CritDamage.gd",
	"res://Code/Combat/Customization/Skills/Passives/Devotion.gd",
	"res://Code/Combat/Customization/Skills/Passives/HighHpBonusDmg.gd",
	"res://Code/Combat/Customization/Skills/Passives/HomingChance.gd",
	"res://Code/Combat/Customization/Skills/Passives/KeenEdge.gd",
	"res://Code/Combat/Customization/Skills/Passives/LastStand.gd",
	"res://Code/Combat/Customization/Skills/Passives/MoralSupport.gd",
	"res://Code/Combat/Customization/Skills/Passives/OverhealBarrier.gd",
	"res://Code/Combat/Customization/Skills/Passives/PierceAdd.gd",
	"res://Code/Combat/Customization/Skills/Passives/PoisonBlade.gd",
	"res://Code/Combat/Customization/Skills/Passives/Regen.gd",
	"res://Code/Combat/Customization/Skills/Passives/Stubborness.gd",
]
var skills = [
	"res://Code/Combat/Customization/Skills/Actives/GoldenSlash.gd",
	"res://Code/Combat/Customization/Skills/Actives/Firebolt.gd",
	]

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
	skill_pool.shuffle()
	refresh_echoes()

func refresh_echoes():
	for i in lechoes + lused_echoes:
		i.get_parent().remove_child(i)
		i.queue_free()
	lechoes = []
	lused_echoes = []
	
	for i in echoes:
		var lecho = load(i).new()
		lechoes.append(lecho)
		add_child(lecho)

func ally_used_skill(skill):
	if skill in lechoes:
		lechoes.erase(skill)
		lused_echoes.append(skill)

func respawn():
	for i in $"/root/Root/CharaCards".get_children():
		i.hp_set(i.get_stat_val("MHP"))
		i.mp_set(i.get_stat_val("MMP"))
		i.dead = false
	$"/root/Root".force_map_switch(respawn_loc, respawn_node)
