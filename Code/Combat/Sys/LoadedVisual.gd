extends Resource

var dir_path
var ava_texture
var bust_texture

func reload(path: String = dir_path):
	var data = GUtil.objectify_json(path)
	dir_path = path
	ava_texture = GUtil.texturize_path(path + data["avatar"])
	bust_texture = GUtil.texturize_path(path + data["base"])

func get_bust():
	return bust_texture

func get_ava():
	return ava_texture

func _init():
	pass
