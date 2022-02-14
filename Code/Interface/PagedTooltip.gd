extends Node

var pages = ["This is page 1", "This is page 2", "This is page 3\nPOI\nPOIPOI\nPOIPOIPOI"]
var curr_page = 0

func _ready():
	disp()

func set_disp(pag):
	pages = pag
	curr_page = 0
	disp()
	$Panel.visible = true

func hide():
	$Panel.visible = false 

func next_page():
	curr_page = (curr_page + 1) % pages.size()
	disp()

func prev_page():
	curr_page = curr_page - 1
	if curr_page < 0:
		curr_page = pages.size() - 1
	disp()

func disp():
	$Panel/RichTextLabel.bbcode_text = pages[curr_page]
	
	if pages.size() > 1:
		$Panel/PageLabel.text = str(curr_page + 1) + "/" + str(pages.size()) + " (scroll)"
		$Panel/PageLabel.visible = true
	else:
		$Panel/PageLabel.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN && event.pressed:
			next_page()
		if event.button_index == BUTTON_WHEEL_UP && event.pressed:
			prev_page()
