extends Panel

class_name MapNode

const IS_MAP_NODE = true

export var is_hidden = false
export var up: NodePath
export var left: NodePath
export var right: NodePath
export var down: NodePath

export var up_ev_override: NodePath
export var left_ev_override: NodePath
export var right_ev_override: NodePath
export var down_ev_override: NodePath

export(String, MULTILINE) var desc
onready var connections = $"../../LineConnections"
onready var map_root = $"../../"

signal node_entered()

func get_desc():
	return parse_desc()

func enter():
	emit_signal("node_entered")
	for i in get_children():
		if i is MapEvent:
			i.activate()

func get_dirs():
	return [up, down, left, right]

const keywords = ["EV"]

func parse_desc():
	var parseable = false
	for i in keywords:
		if i in desc:
			parseable = true
	
	if parseable:
		var event_names = RegEx.new()
		event_names.compile("EV (.*)")
		var event_descriptors = RegEx.new()
		event_descriptors.compile("(\\[.*\\])")
		
		var key_ev = 0
		var count = 0
		for i in event_names.search_all(desc):
			count += 1
			if i.get_string(1) in GPlayer.flags.keys():
				if GPlayer.flags[i.get_string(1)] == true:
					key_ev = count
					break
		return event_descriptors.search_all(desc)[key_ev].get_string(0).replace("[", "").replace("]","")
		
	else:
		return desc

func _ready():
	if is_hidden:
		self_modulate.a = 0.2
	
	for i in get_dirs():
		if !i.is_empty() && !is_hidden:
			if !get_node(i).is_hidden:
				var ln = Line2D.new()
				ln.add_point(rect_position + rect_size/2)
				ln.add_point(get_node(i).rect_position + get_node(i).rect_size/2)
				connections.add_child(ln)
