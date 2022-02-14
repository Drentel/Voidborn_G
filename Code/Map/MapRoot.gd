extends Control

signal node_entered(node)
signal node_exited(node)
signal buttons_passed(buttons)

var current: Node

var first_instant_move = true

export var map_name = "Map name here"

func _ready():
	current = get_node("MapNodes").get_children()[0]
	for i in get_node("MapNodes").get_children():
		if i is MapNode:
			i.connect("node_entered", self, "map_node_entered", [i])
	emit_signal("node_entered", current)
	recursive_button_sub()
	yield(get_tree(), "idle_frame")
	current.enter()

func switch_map(map_path, dest):
	var new_map = load(map_path).instance()
	var parent = get_parent()
	parent.remove_child(self)
	new_map.find_node("MapNodes").move_child(new_map.find_node("MapNodes").find_node(dest), 0)
	parent.add_child(new_map)
	parent.get_parent().root_path = map_path
	queue_free()

func recursive_button_sub(node = self):
	if node is MapButtonEvent:
		node.connect("buttons_required", self, "pass_buttons")
	
	for i in node.get_children():
		recursive_button_sub(i)

func pass_buttons(buttons):
	emit_signal("buttons_passed", buttons)

func map_node_entered(node):
	emit_signal("node_exited", current)
	if !first_instant_move:
		movebetween(node)
	else:
		rect_position = Vector2(206, 206) - node.rect_position
		first_instant_move = false
	current = node
	emit_signal("node_entered", node)

func move_up():
	var allow = true
	if !current.up_ev_override.is_empty():
		allow = current.get_node(current.up_ev_override).activate()
	
	if !current.up.is_empty() && allow:
		current.get_node(current.up).enter()

func move_down():
	var allow = true
	if !current.down_ev_override.is_empty():
		allow = current.get_node(current.down_ev_override).activate()
	
	if !current.down.is_empty() && allow:
		current.get_node(current.down).enter()

func move_left():
	var allow = true
	if !current.left_ev_override.is_empty():
		allow = current.get_node(current.left_ev_override).activate()
	
	if !current.left.is_empty() && allow:
		current.get_node(current.left).enter()

func move_right():
	var allow = true
	if !current.right_ev_override.is_empty():
		allow = current.get_node(current.right_ev_override).activate()
	
	if !current.right.is_empty() && allow:
		current.get_node(current.right).enter()

func movebetween(dest):
	$Tween.interpolate_property(self, "rect_position",
		rect_position, Vector2(206, 206) - dest.rect_position, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
