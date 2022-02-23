extends BaseArtiStatus

var stacks = 0

func _init():
	status_name = "FOC"

func _ready():
	status_owner.connect("sent_dmg", self, "on_sent_dmg")
	status_owner.connect("critted", self, "on_crit")

func get_desc():
	return """FOC
Crit rate (CTR) increased by """ + str(stacks) + ". This bonus is increased by 1~" + str(max(lvl,2 )) + " when character attacks but doesn't crit, but reset when a crit happens"

func on_sent_dmg(inst: DamageInstance):
	if !inst.did_crit:
		stacks += max(1, randi()%int(max(lvl, 2))+1)
		GUtil.annihilate_children(self)
		var inf = Influencer.new()
		inf.target_stat = "CTR"
		inf.influence = stacks
		add_child(inf)

func on_crit(_instance):
	stacks = 0
	GUtil.annihilate_children(self)
