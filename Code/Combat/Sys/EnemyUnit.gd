extends UnitBase

export var growth = {
	"MHP": 1.0, 
	"MMP": 1.0, 
	"ATK": 1.0, 
	"CRM": 1.0, 
	"TEC": 1.0, 
	"DEF": 1.0, 
	"AUR": 1.0, 
	"CTR": 1.0, 
	"CTD": 1.0, 
	"SPD": 1.0, 
	"HIT": 1.0, 
	"AVD": 1.0, 
	"ABS": 1.0,
}

export var base = {
	"MHP": 0, 
	"MMP": 100, 
	"ATK": 0, 
	"CRM": 0, 
	"TEC": 0, 
	"DEF": 0, 
	"AUR": 0, 
	"CTR": 0, 
	"CTD": 50, 
	"SPD": 0, 
	"HIT": 0, 
	"AVD": 0, 
	"ABS": 0,
}

func _ready():
	hp = get_stat_val("MHP")
	mp = get_stat_val("MMP")

func die():
	get_parent().remove_child(self)
	.die()
	queue_free()

func get_stat_val(stat: String):
	return max(ceil(growth[stat]*lvl + _gather_inlfuencers(stat))+base[stat], 1)

func get_base_stat_val(stat: String):
	return ceil(growth[stat]*lvl)+base[stat]
