extends MapEvent

func activate():
	for i in $"/root/Root/CharaCards".get_children():
		i.revive()
		i.hp_set(i.get_stat_val("MHP"))
		i.mp_set(i.get_stat_val("MMP"))
		
		GPlayer.respawn_loc = $"/root/Root".get_map_root().root_path
		GPlayer.respawn_node = root_node.name
		GPlayer.refresh_echoes()
