extends Button
class_name ClackButton

func _ready():
	var pre = AudioStreamPlayer.new()
	pre.name = "Press"
	add_child(pre)
	var hov = AudioStreamPlayer.new()
	hov.name = "Hover"
	add_child(hov)
	
	set_profile()
	
	$Press.volume_db = GPlayer.settings["SFX_VOL"]
	connect("pressed", self, "play_press")
	
	$Hover.volume_db = GPlayer.settings["SFX_VOL"]
	connect("mouse_entered", self, "play_hover")

func set_profile(prof = "basic"):
	if prof == "basic":
		$Press.stream = load("res://Audio/77.mp3")
		$Hover.stream = load("res://Audio/122.mp3")

func play_press():
	if not disabled:
		$Press.play()

func play_hover():
	if not disabled:
		$Hover.play()
