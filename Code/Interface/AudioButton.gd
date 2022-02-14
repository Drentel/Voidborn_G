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
	connect("pressed", $Press, "play")
	
	$Hover.volume_db = GPlayer.settings["SFX_VOL"]
	connect("mouse_entered", $Hover, "play")

func set_profile(prof = "basic"):
	if prof == "basic":
		$Press.stream = load("res://Audio/77.mp3")
		$Hover.stream = load("res://Audio/122.mp3")
