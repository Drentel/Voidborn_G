extends Control

var root
var root_path

func _ready():
	rebind()

func rebind():
	if get_tree():
		yield(get_tree(), "idle_frame")
	
	
	GUtil.safe_connect($MapOverlay/BtnDown, "pressed", $MapRect/MapRoot, "move_down")
	GUtil.safe_connect($MapOverlay/BtnLeft, "pressed", $MapRect/MapRoot, "move_left")
	GUtil.safe_connect($MapOverlay/BtnRight, "pressed", $MapRect/MapRoot, "move_right")
	GUtil.safe_connect($MapOverlay/BtnUp, "pressed", $MapRect/MapRoot, "move_up")
	
	GUtil.safe_connect($MapRect/MapRoot, "node_entered", $LocDesc, "desc")
	GUtil.safe_connect($MapRect/MapRoot, "node_exited", $MapActions, "clear")
	GUtil.safe_connect($MapRect/MapRoot, "buttons_passed", $MapActions, "handle_buttons")
	
	$MapRect/MapRoot.connect("tree_exited", self, "rebind")
	
	$BigMapName.text = $MapRect/MapRoot.map_name
	if $BigMapName/AnimationPlayer.is_playing():
		$BigMapName/AnimationPlayer.stop()
	$BigMapName/AnimationPlayer.play("MapTextAnim")

	$LocDesc.desc($MapRect/MapRoot.current)
	root = $MapRect/MapRoot
