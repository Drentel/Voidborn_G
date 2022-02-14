extends Node

var canv

func afflict(rect, text):
	var txt = load("res://Scenes/SFX/DamageLabel.tscn").instance()
	txt.text = text
	canv.add_child(txt)
	var totpos = rect.position
	if rect.size.x - txt.rect_size.x > 0:
		totpos.x += randi()%int(rect.size.x - txt.rect_size.x)
	if rect.size.y - txt.rect_size.y > 0:
		totpos.y += randi()%int(rect.size.y - txt.rect_size.y)
	txt.rect_position = totpos

func heal_particles(rect):
	var particles = preload("res://Scenes/SFX/HealParticles.tscn").instance()
	particles.process_material.emission_box_extents = Vector3(rect.size.x/2, rect.size.y/2, 1)
	canv.add_child(particles)
	particles.position = Vector2(rect.position.x + rect.size.x/2, rect.position.y + rect.size.y/2)
	particles.emitting = true

func spawn_smoke():
	var smoke = preload("res://Scenes/SFX/SmokeParticles.tscn").instance()
	canv.add_child(smoke)
	smoke.position = Vector2(800, 500)
	smoke.emitting = true

func dmg_num(rect, inst):
	var num = load("res://Scenes/SFX/DamageLabel.tscn").instance()
	num.text = str(inst.amount)
	canv.add_child(num)
	var totpos = rect.position
	if rect.size.x - num.rect_size.x > 0:
		totpos.x += randi()%int(rect.size.x - num.rect_size.x)
	if rect.size.y - num.rect_size.y > 0:
		totpos.y += randi()%int(rect.size.y - num.rect_size.y)
	num.rect_position = totpos
	
	if inst.dmg_type == DamageInstance.TYPE.HEAL:
		num.add_color_override("font_color", Color.aquamarine)
	elif inst.did_crit:
		num.add_color_override("font_color", Color.orangered)

func generic_text(rect, text, color = Color.white):
	var num = load("res://Scenes/SFX/DamageLabel.tscn").instance()
	num.text = text
	canv.add_child(num)
	var totpos = rect.position
	if rect.size.x - num.rect_size.x > 0:
		totpos.x += randi()%int(rect.size.x - num.rect_size.x)
	if rect.size.y - num.rect_size.y > 0:
		totpos.y += randi()%int(rect.size.y - num.rect_size.y)
	num.rect_position = totpos
	
	num.add_color_override("font_color", color)

var effect_names = {
	"bell": preload("res://Scenes/SFX/BellImpact.tscn"),
	"claymore": preload("res://Scenes/SFX/ClaymoreImpact.tscn"),
	"sword": preload("res://Scenes/SFX/SwordImpact.tscn"),
	"rapier": preload("res://Scenes/SFX/RapierImpact.tscn"),
	"ice": preload("res://Scenes/SFX/IceImpact.tscn"),
	"shield": preload("res://Scenes/SFX/ShieldEffect.tscn"),
	"bigslash": preload("res://Scenes/SFX/SlashBig.tscn"),
	"blood": preload("res://Scenes/SFX/Blood.tscn"),
	"buff1": preload("res://Scenes/SFX/Buff1.tscn"),
	"lightning": preload("res://Scenes/SFX/Lightning.tscn"),
	"swordup": preload("res://Scenes/SFX/SwordUp.tscn"),
	"smoke": preload("res://Scenes/SFX/Smoke.tscn"),
}

func frame_sfx(name, rect, modulate=Color.white, flip_h = false, flip_v = false, center=true):
	var spr = effect_names[name].instance()
	spr.modulate = modulate
	spr.flip_h = flip_h
	spr.flip_v = flip_v
	canv.add_child(spr)
	if !center:
		spr.position.x = rect.position.x + randi()%int(rect.size.x)
		spr.position.y = rect.position.y + randi()%int(rect.size.y)
	else:
		spr.position = rect.position + rect.size/2

func _ready():
	canv = CanvasLayer.new()
	canv.layer = 2
	add_child(canv)
