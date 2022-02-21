extends Node
class_name BaseSkill

# You need to override this in _init for other skills
var s_name = "Pass"
var s_desc = "End the turn"

func show_desc_tip(owner):
	Tip.set_disp([s_desc])

func check_usability(_unit):
	return true

func find_manager():
	return $"/root/Root".get_combat()

func use(user):
	user.emit_signal("skill_start", self)
	Curtain.ln(user.name + " passed the turn")
	yield(get_tree().create_timer(0.1), "timeout")
	user.emit_signal("skill_end", self)
	user.end_turn()
