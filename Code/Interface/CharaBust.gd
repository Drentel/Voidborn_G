extends TextureRect

onready var def_tex = texture
onready var def_pos = rect_position
onready var def_size = rect_size

func _ready():
	rebind()

func rebind():
	for i in get_parent().get_characters():
		GUtil.safe_connect(i, "selected", self, "unit_selected", [i])
	unit_selected($"/root/Root".get_characters()[0])

func unit_selected(unit):
	if unit.skin_dir != "":
		var js = GUtil.objectify_json(unit.skin_dir + "/portrait.json")
		texture = GUtil.texturize_path(unit.skin_dir + js["base"])
		
		rect_size.x = 900 + unit.zoom_adjust
		rect_size.y = 1600 + unit.zoom_adjust
		rect_position = unit.pos_adjust
		flip_h = unit.flip
	else:
		texture = def_tex
		rect_size = def_size
		rect_position = def_pos
