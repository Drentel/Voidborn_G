extends Control

export var DialogueJson: String
var line = 0
var lines

func _ready():
	lines = GUtil.objectify_json(DialogueJson)
	next_line()

func next_line():
	if line >= lines.size():
		queue_free()
		return
	if lines[line]["speaker"].length() == 0:
		$Panel2.visible = false
	else:
		$Panel2.visible = true
	$Speaker.bbcode_text = lines[line]["speaker"]
	$Line.bbcode_text = lines[line]["line"]
	if $Tween.is_active():
		$Tween.remove($Line)
	$Tween.interpolate_property($Line, "percent_visible", 0.0, 1.0, lines[line]["line"].length()*0.015)
	$Tween.start()
	line += 1


func _on_SkipBtn_pressed():
	queue_free()
