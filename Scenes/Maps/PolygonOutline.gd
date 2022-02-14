extends Polygon2D

export var width = 5
export var col = Color.red

func _ready():
	var ln = Line2D.new()
	for i in polygon:
		ln.add_point(i)
	ln.add_point(polygon[0])
	ln.width = width
	ln.default_color = col
	ln.antialiased = true
	add_child(ln)
