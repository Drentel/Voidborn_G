extends Node

var settings = {
	"SFX_VOL": -18,
	"MUS_VOL": -18,
}

var flags = {}
var generic_items = {}
var pacts = []
var equip_items = []
var money = 1000
var respawn_loc = "res://Scenes/Maps/Level1.tscn"
var respawn_node = "Fountain"
var reserve_characters = []

func get_item(item_name):
	if item_name in generic_items:
		return generic_items[item_name]
	else:
		return 0

func _ready():
	pass
	#for i in range(20):
	#	equip_items.append(GUtil.make_weapon(i))
	#	equip_items.append(GUtil.make_arti(i))
		
	#for _i in range(5):
	#	reserve_characters.append(load("res://Scenes/CharaCard.tscn").instance())

func respawn():
	for i in $"/root/Root/CharaCards".get_children():
		i.hp_set(i.get_stat_val("MHP"))
		i.mp_set(i.get_stat_val("MMP"))
		i.dead = false
	$"/root/Root".force_map_switch(respawn_loc, respawn_node)
