extends MapEvent

export var map_path = "res://Scenes/Maps/StartMap.tscn"
export var dest_node_name = "Fountain"

func activate():
	root_node.map_root.switch_map(map_path, dest_node_name)
