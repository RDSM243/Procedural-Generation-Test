extends Camera2D

var mpos
var cam_offset_divider = 20

func _process(delta):
	mpos = get_local_mouse_position() 
	offset = mpos / cam_offset_divider
	pass
