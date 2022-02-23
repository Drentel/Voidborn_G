extends WindowDialog

var rot
var targ_level = 0
var money_cost = 0
var item_cost = {}
var confirm_possible = false

const cost_additions = {
	25: "Mundane soul shard",
	50: "Unusual soul shard",
	75: "Extraordinary soul shard",
}

const cost_per_lvl = 10
const limit_break_item = "God's flesh"
const limit_break_treshold = 99

func _ready():
	get_parent().connect("pressed", self, "show")
	rot = $"../../"

func show():
	targ_level = 0
	upd()
	popup_centered()

func upd():
	$CurrentLevelLabel.text = str(rot.unit.lvl)
	if targ_level <= rot.unit.lvl:
		targ_level = rot.unit.lvl + 1
	
	if targ_level == rot.unit.lvl + 1:
		$BtnMinus.disabled = true
		$BtnMinus2.disabled = true
	else:
		$BtnMinus.disabled = false
		$BtnMinus2.disabled = false
	$TargetLevelLabel.text = str(targ_level)
	
	money_cost = 0
	item_cost = {}
	for i in range(rot.unit.lvl+1, targ_level+1):
		money_cost += i*cost_per_lvl
		if i in cost_additions:
			if i in item_cost:
				item_cost[cost_additions[i]] += 1
			else:
				item_cost[cost_additions[i]] = 1
		if i > limit_break_treshold:
			if limit_break_item in item_cost:
				item_cost[limit_break_item] += 1
			else:
				item_cost[limit_break_item] = 1
	
	confirm_possible = true
	
	$CostsLabel.bbcode_text = ""
	if money_cost <= GPlayer.money:
		$CostsLabel.bbcode_text += str(money_cost) + "/" + str(GPlayer.money) + " Macca\n"
	else:
		confirm_possible = false
		$CostsLabel.bbcode_text += "[color=red]"
		$CostsLabel.bbcode_text += str(money_cost) + "/" + str(GPlayer.money) + " Macca"
		$CostsLabel.bbcode_text += "[/color]\n"
	
	for i in item_cost:
		if item_cost[i] <= GPlayer.get_item(i):
			$CostsLabel.bbcode_text += str(item_cost[i]) + "/" + str(GPlayer.get_item(i)) + "x " + i + "\n"
		else:
			confirm_possible = false
			$CostsLabel.bbcode_text += "[color=red]"
			$CostsLabel.bbcode_text += str(item_cost[i]) + "/" + str(GPlayer.get_item(i)) + "x " + i
			$CostsLabel.bbcode_text += "[/color]\n"
	
	if confirm_possible:
		$ConfirmBtn.disabled = false
	else:
		$ConfirmBtn.disabled = true

func _on_BtnPlus_pressed():
	targ_level += 1
	upd()

func _on_BtnMinus_pressed():
	targ_level -= 1
	upd()

func _on_BtnMinus2_pressed():
	targ_level -= 10
	upd()

func _on_BtnPlus2_pressed():
	targ_level += 10
	upd()


func _on_ConfirmBtn_pressed():
	GPlayer.money_set(GPlayer.money - money_cost)
	for i in item_cost:
		GPlayer.generic_items[i] -= item_cost[i]
	
	rot.unit.lvl = targ_level
	rot.unit.unpack()
	rot.upd_vals()
	
	visible = false
