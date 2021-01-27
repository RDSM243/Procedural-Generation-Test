extends Node2D

var stats = []

func _process(delta):
	var label_text = ""
	
	#putting FPS on the overlay
	var fps = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps)
	label_text += "\n"
	
	#putting memory usage in the overlay
	var mem = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(mem))
	label_text += "\n"
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += str(s[0], ": ", value)
		label_text += "\n"
	
	$Label.text = label_text
	pass

func add_stat(stat_name, object, stat_ref, is_method):
	stats.append([stat_name, object, stat_ref, is_method])
	pass
