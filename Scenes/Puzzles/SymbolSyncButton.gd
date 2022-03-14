extends ClackButton

export var connections = []

signal switched()

const symbols = [
	"f",
	"z",
	"0",
]

func _ready():
	for i in connections:
		var ln = Line2D.new()
		ln.add_point(rect_position + rect_size/2)
		ln.add_point(get_node(i).rect_position + get_node(i).rect_size/2)
		$"../../Connections".add_child(ln)
	
	connect("pressed", self, "on_press")

func on_press():
	switch()
	switch_connections()
	emit_signal("switched")

func switch():
	text = symbols[(symbols.find(text) + 1) % symbols.size()]

func switch_connections():
	for i in connections:
		get_node(i).switch()
