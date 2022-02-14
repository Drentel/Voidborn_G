extends Control

var reserve
var swap = ""

func _ready():
	reserve = $Panel/GridContainer
	gen_interaction()
	Curtain.ln("Click on characters to swap their positions")

func _on_CloseBtn_pressed():
	for i in GPlayer.reserve_characters:
		i.get_parent().remove_child(i)
	get_parent().remove_child(self)
	queue_free()

func gen_interaction():
	GUtil.soft_annihilate_children(reserve)
	GUtil.annihilate_children($SwapBtns)
	
	if GPlayer.reserve_characters != []:
		for i in GPlayer.reserve_characters:
			reserve.add_child(i)
		$Panel.visible = true
	else:
		$Panel.visible = false
		
	var all_chars = $"/root/Root".get_characters() + reserve.get_children()
	yield(get_tree(), "idle_frame")
	for i in all_chars:
		var btn = Button.new()
		btn.modulate.a = 0.5
		btn.rect_global_position = i.rect_global_position
		btn.rect_size = i.rect_size
		btn.set_meta("chara", i)
		btn.connect("pressed", self, "on_char_selected", [btn])
		$SwapBtns.add_child(btn)

func on_char_selected(btn: Button):
	if swap is String:
		swap = btn.get_meta("chara")
	else:
		var swap2 = btn.get_meta("chara")
		if swap.get_parent() == swap2.get_parent():
			var idx = swap.get_index()
			if reserve == swap.get_parent():
				GUtil.arr_swap(GPlayer.reserve_characters, swap, swap2)
			swap.get_parent().move_child(swap, swap2.get_index())
			swap2.get_parent().move_child(swap2, idx)
		else:
			var party_char
			var reserve_char
			
			if swap.get_parent() == reserve:
				reserve_char = swap
				party_char = swap2
			else:
				reserve_char = swap2
				party_char = swap
			
			var party_char_idx = party_char.get_index()
			var reserve_char_idx = reserve_char.get_index()
			
			$"/root/Root".get_character_root().remove_child(party_char)
			GPlayer.reserve_characters.erase(reserve_char)
			reserve.remove_child(reserve_char)
			
			$"/root/Root".get_character_root().add_child(reserve_char)
			$"/root/Root".get_character_root().move_child(reserve_char, party_char_idx)
			
			GPlayer.reserve_characters.insert(reserve_char_idx, party_char)
		swap = ""
		$"/root/Root".notify_party_changed()
	
	btn.get_parent().remove_child(btn)
	btn.queue_free()
	if swap is String:
		gen_interaction()
