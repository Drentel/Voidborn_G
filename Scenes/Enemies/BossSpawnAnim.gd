extends Tween

func _ready():
	interpolate_property(get_parent(), "rect_position",
		get_parent().rect_position - Vector2(0, -200), get_parent().rect_position, 2,
		Tween.TRANS_LINEAR)
	$"/root/Root".screen_shake(3)
	start()
