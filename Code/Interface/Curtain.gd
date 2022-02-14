extends Panel

var height
var def_height
var unreads = 0

func _ready():
	def_height = rect_position.y
	height = def_height + 344
	_to_bottom()

func _to_bottom():
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scrollbar().max_value

func _on_Curtain_mouse_entered():
	unreads = 0
	$Unread.visible = false
	rect_position.y = height
	self_modulate.a = 0.8

func _on_Curtain_mouse_exited():
	rect_position.y = def_height
	self_modulate.a = 0.5
	_to_bottom()

func ln(text: String):
	$ScrollContainer/Label.text += "\n"+text
	yield(get_tree(),"idle_frame")
	unreads += 1
	$Unread.text = str(unreads) + " New"
	$Unread.visible = true
	_to_bottom()
