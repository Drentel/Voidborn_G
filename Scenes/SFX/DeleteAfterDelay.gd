extends Node

export var delay = 1.0

func _ready():
	yield(get_tree().create_timer(delay), "timeout")
	get_parent().remove_child(self)
	queue_free()
