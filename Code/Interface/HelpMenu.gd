extends Popup

var group = ButtonGroup.new()

func _ready():
	for i in $Panel/ScrollContainer/VBoxContainer.get_children():
		i.toggle_mode = true
		i.group = group
	
	group.connect("pressed", self, "on_button_pressed")

func _on_HelpButton_pressed():
	popup_centered()

func on_button_pressed(btn):
	$RichTextLabel.bbcode_text = btn.get_children()[0].bbcode_text
