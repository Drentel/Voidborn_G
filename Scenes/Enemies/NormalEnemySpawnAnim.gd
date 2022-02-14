extends Tween

func _ready():
	interpolate_property(get_parent(), "rect_position",
		get_parent().rect_position - Vector2((randi()%1000)-500, 1000), get_parent().rect_position, 0.5,
		Tween.TRANS_LINEAR)
	start()
