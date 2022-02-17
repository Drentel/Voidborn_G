extends BaseAI

var summons_procced = false
var buffs_applied = false

func act():
	yield(get_tree(), "idle_frame")
	if !summons_procced and get_parent().hp < (get_parent().get_stat_val("MHP")/3)*2:
		summons_procced = true
		$"../Summon".use(get_parent())
	elif !buffs_applied and get_parent().hp < get_parent().get_stat_val("MHP")/3:
		buffs_applied = true
		$"../SelfBuff".use(get_parent())
	else:
		$"../Attack".use(get_parent())
