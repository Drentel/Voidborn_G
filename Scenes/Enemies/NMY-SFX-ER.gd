extends Node


func _ready():
	get_parent().connect("pre_applied_dmg", self, "on_dmg")
	get_parent().connect("turn_start", self, "on_turn_start")

func on_dmg(_garbage):
	$HurtAnim.play("HurtAnim")

func on_turn_start():
	$ActAnim.play("ActAnim")
