extends ClackButton

export var connections = []

signal switched()

const symbols = [
	"P",
	"Q",
	"X",
]

func _ready():
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
