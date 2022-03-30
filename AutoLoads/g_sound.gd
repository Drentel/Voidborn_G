extends Node

var effects = {
	"btnPress": load("res://Audio/multimedia_button_click_018.mp3"),
	"btnHover": load("res://Audio/multimedia_button_click_013.mp3"),
}

func _ready():
	for i in effects.keys():
		var pla = AudioStreamPlayer.new()
		pla.volume_db = GPlayer.settings["SFX_VOL"]
		pla.stream = effects[i]
		add_child(pla)
		effects[i] = pla

func play(eff):
	effects[eff].play()
