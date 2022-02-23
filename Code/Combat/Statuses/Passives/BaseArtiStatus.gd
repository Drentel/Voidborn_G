extends BaseStatus
class_name BaseArtiStatus

var lvl = 1

func _init():
	status_name = "STA"

func get_desc():
	return "REG\nDoes someyhing at level " + str(lvl)

# This ususally will not be called for statuses that are inflicted by artifact passives
func handle_dupe(dupe):
	lvl = max(dupe.lvl, lvl)
