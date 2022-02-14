extends Resource
class_name DamageInstance

enum TYPE {
	MAG,
	PHYS,
	HEAL,
}

signal pre_dmg_adjusted()
signal pre_dmg_applied()
signal dmg_applied()

#These two are UnitBase-s but circular dependency yada yada
var sender
var target
var amount: int
#DEF ignore 
#var is_pierce: bool = false
var pierce: float = 0.0
#AVD ignore
var is_homing: bool = false
#Is attack able to crit
var is_able_crit: bool = true
#Did it crit on the way
var did_crit: bool = false
var dmg_type: int = 0

func _init():
	pass
